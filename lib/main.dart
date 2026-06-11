import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HttpDemoScreen(),
    );
  }
}

class HttpDemoScreen extends StatefulWidget {
  const HttpDemoScreen({super.key});

  @override
  State<HttpDemoScreen> createState() => _HttpDemoScreenState();
}

class _HttpDemoScreenState extends State<HttpDemoScreen> {
  String _getResult = 'No data fetched yet';
  String _postResult = 'No data posted yet';
  bool _isLoadingGet = false;
  bool _isLoadingPost = false;

  // 1. GET Request Function
  Future<void> makeGetRequest() async {
    setState(() {
      _isLoadingGet = true;
    });

    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successfully fetched data
        final data = jsonDecode(response.body);
        setState(() {
          _getResult = 'Title: ${data['title']}\n\nBody: ${data['body']}';
        });
      } else {
        setState(() {
          _getResult = 'Failed to load data. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _getResult = 'Error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoadingGet = false;
      });
    }
  }

  // 2. POST Request Function
  Future<void> makePostRequest() async {
    setState(() {
      _isLoadingPost = true;
    });

    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': 'Flutter Assignment',
          'body': 'This is a successful POST request!',
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully created data
        final data = jsonDecode(response.body);
        setState(() {
          _postResult = 'Success!\nCreated ID: ${data['id']}\nTitle: ${data['title']}';
        });
      } else {
        setState(() {
          _postResult = 'Failed to post data. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _postResult = 'Error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoadingPost = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP GET & POST Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // GET Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('GET Request Example', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _isLoadingGet 
                        ? const CircularProgressIndicator() 
                        : Text(_getResult, style: const TextStyle(color: Colors.black87)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: makeGetRequest,
                      child: const Text('Fetch Data (GET)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // POST Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('POST Request Example', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _isLoadingPost 
                        ? const CircularProgressIndicator() 
                        : Text(_postResult, style: const TextStyle(color: Colors.black87)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: makePostRequest,
                      child: const Text('Send Data (POST)'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
