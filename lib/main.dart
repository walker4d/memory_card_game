import 'dart:async';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'images/images.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("YUGIOH!! memory game!!"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            new Image.asset('assets/duel1.gif'),
            new Text("welcome to yugioh memory card Game",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            new RaisedButton(
              child: Text("Duel"),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Game(),
                  ),
                );
              },
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.grey,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 10,
      navigateAfterSeconds: new GamePage(),
      title: new Text(
        'Yugioh Memory Game!! Test your might!!',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset('assets/original.gif'),
      photoSize: 100.0,
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}

class Game extends StatefulWidget {
  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
  int time = 0;
  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time = time + 1;
      });
    });
  }

  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];
  List<int> data = [];
  int previousIndex = -1;
  bool flip = false;
  Timer timer;
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 8; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }
    for (var i = 0; i < 8 ~/ 2; i++) {
      data.add(i);
    }
    for (var i = 0; i < 8 ~/ 2; i++) {
      print(i);

      data.add(i);
    }
    startTimer();
    data.shuffle();
  }

  int level = 8;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("memoery game"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Time $time",
                style: Theme.of(context).textTheme.display2,
              ),
            ),
            Theme(
              data: ThemeData.dark(),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) => FlipCard(
                    key: cardStateKeys[index],
                    onFlip: () {
                      if (!flip) {
                        flip = true;
                        previousIndex = index;
                      } else {
                        flip = false;
                        if (previousIndex != index) {
                          if (data[previousIndex] != data[index]) {
                            cardStateKeys[previousIndex]
                                .currentState
                                .toggleCard();
                            previousIndex = index;
                          } else {
                            cardFlips[previousIndex] = false;
                            cardFlips[index] = false;
                            print(cardFlips[index]);

                            if (cardFlips.every((t) => t == false)) {
                              print("Won");
                              showResult();
                            }
                          }
                        }
                      }
                    },
                    direction: FlipDirection.HORIZONTAL,
                    flipOnTouch: cardFlips[index],
                    front: Container(
                      margin: EdgeInsets.all(4.0),
                      height: 500,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage('assets/back.png'),
                              fit: BoxFit.fill)),
                    ),
                    back: Container(
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image:
                                  AssetImage('${imageList[data[index]].name}'),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  itemCount: data.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showResult() {
    showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              image: Image.asset('assets/win.gif'),
              title: Text('You Won!! you are the king of games',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
              description: Text(
                'Your time score was $time',
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.BOTTOM_LEFT,
              onlyOkButton: true,
              buttonOkText: Text('Return'),
              onOkButtonPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GamePage(),
                  ),
                );
              },
            ));
  }
}
