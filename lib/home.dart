import 'package:flutter/material.dart';
import 'package:tic_tac_game/game_logic.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Game game = Game();
  bool isSwitched = false;
  String activePlayer = 'X'; //X or O
  bool gameover = false;
  int turn = 0;
  String result = ' ';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: width < 600
            ? Column(
                children: [
                  SwitchListTile.adaptive(
                    activeColor: Theme.of(context).splashColor,
                    title: const Text(
                      textAlign: TextAlign.center,
                      'switch on /off tow player',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    value: isSwitched,
                    onChanged: (selectedval) {
                      setState(() {
                        isSwitched = selectedval;
                      });
                    },
                  ),
                  Text(
                    "it's $activePlayer turn",
                    style: const TextStyle(color: Colors.white, fontSize: 50),
                  ),
                  // mytext(result, 50),
                  Expanded(
                    child: GridView.count(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(8.0),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                      children: List.generate(
                        9,
                        (index) => InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: gameover ? null : () => _onTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                                child: Text(
                                    Player.playerX.contains(index)
                                        ? 'X'
                                        : Player.playerO.contains(index)
                                            ? 'O'
                                            : '',
                                    style: TextStyle(
                                        color: Player.playerX.contains(index)
                                            ? Theme.of(context).splashColor
                                            : const Color.fromARGB(
                                                255, 233, 30, 99),
                                        fontSize: 50))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  mytext(result, 50),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        gameover = false;
                        // isSwitched = false;
                        activePlayer = 'X';
                        turn = 0;
                        result = '';
                        Player.playerX = [];
                        Player.playerO = [];
                        print(width);
                      });
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('replay the game '),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).splashColor)),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    width: width,
                    child: SwitchListTile.adaptive(
                      activeColor: Theme.of(context).splashColor,
                      title: const Text(
                        textAlign: TextAlign.center,
                        'switch on /off tow player',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      value: isSwitched,
                      onChanged: (selectedval) {
                        setState(() {
                          isSwitched = selectedval;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: width / 2,
                            height: 320,
                            child: GridView.count(
                              padding: const EdgeInsets.all(8.0),
                              crossAxisCount: 3,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 1.0,
                              children: List.generate(
                                9,
                                (index) => InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: gameover ? null : () => _onTap(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).shadowColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                        child: Text(
                                            Player.playerX.contains(index)
                                                ? 'X'
                                                : Player.playerO.contains(index)
                                                    ? 'O'
                                                    : '',
                                            style: TextStyle(
                                                color: Player.playerX
                                                        .contains(index)
                                                    ? Theme.of(context)
                                                        .splashColor
                                                    : const Color.fromARGB(
                                                        255, 233, 30, 99),
                                                fontSize: 50))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "it's $activePlayer turn",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 50),
                          ),
                          mytext(result, 40),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                gameover = false;
                                // isSwitched = false;
                                activePlayer = 'X';
                                turn = 0;
                                result = '';
                                Player.playerX = [];
                                Player.playerO = [];
                                print(width);
                              });
                            },
                            icon: const Icon(Icons.replay),
                            label: const Text('replay the game '),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).splashColor)),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }

  _onTap(index) async {
    // play

//|| Player.playerX.isEmpty
//|| Player.playerO.isEmpty

    if ((!Player.playerX.contains(index)) &&
        (!Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateMethod();
    }
    if (!isSwitched && !gameover) {
      await game.autoPlay(activePlayer);
      updateMethod();
    }
  }

  void updateMethod() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String winerPlayer = Game().checkWinner();
      if (winerPlayer != '') {
        gameover = true;
        result = '$winerPlayer is the winner';
      } else if (!gameover && turn == 9) {
        result = "it's Draw !";
      }
    });
  }
}

Widget mytext(String text, double fontSize) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.white, fontSize: fontSize),
  );
}
