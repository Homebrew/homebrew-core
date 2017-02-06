class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"

  # The OS X version doesn't contain a Makefile, so we
  # need to download the Linux version
  url "https://sites.google.com/site/broguegame/brogue-1.7.4-linux-amd64.tbz2"
  version "1.7.4"
  sha256 "eba5f35fe317efad9c97876f117eaf7a26956c435fdd2bc1a5989f0a4f70cfd3"

  # put the highscores file in HOMEBREW_PREFIX/var/brogue/ instead of a
  # version-dependent location.
  patch :DATA

  bottle do
    cellar :any_skip_relocation
    sha256 "f5c2b2946ecd5c601b424b3f05181a6716707063de42ab7a27bac1a8c07bc290" => :el_capitan
    sha256 "94ed4b691fdaa5dc7de98421b7ebb66fe8ea9d43c427aaa37fba5fc89f287feb" => :yosemite
    sha256 "6263ae6a78f59f4a95690c35075b7f3156cddb53063f2c2564024ebc78c0bab2" => :mavericks
  end

  def install
    (var/"brogue").mkpath

    doc.install "Readme.rtf" => "README.rtf"
    doc.install "agpl.txt" => "COPYING"

    system "make", "clean", "curses"

    # The files are installed in libexec
    # and the provided `brogue` shell script,
    # which is just a convenient way to launch the game,
    # is placed in the `bin` directory.
    inreplace "brogue", %r{`dirname \$0`/bin$}, libexec
    bin.install "brogue"
    libexec.install "bin/brogue", "bin/keymap"
  end

  def caveats; <<-EOS.undent
    If you are upgrading from 1.7.2, you need to copy your highscores file:
        cp #{HOMEBREW_PREFIX}/Cellar/#{name}/1.7.2/BrogueHighScores.txt #{var}/brogue/
    EOS
  end

  test do
    system "#{bin}/brogue", "--version"
  end
end

__END__
--- a/src/platform/platformdependent.c	2013-10-08 21:53:15.000000000 +0200
+++ b/src/platform/platformdependent.c	2013-10-08 21:55:22.000000000 +0200
@@ -75,7 +75,7 @@
 	short i;
 	FILE *scoresFile;

-	scoresFile = fopen("BrogueHighScores.txt", "w");
+	scoresFile = fopen("HOMEBREW_PREFIX/var/brogue/BrogueHighScores.txt", "w");
 	for (i=0; i<HIGH_SCORES_COUNT; i++) {
 		fprintf(scoresFile, "%li\t%li\t%s", (long) 0, (long) 0, "(empty entry)\n");
 	}
@@ -128,11 +128,11 @@
 	time_t rawtime;
 	struct tm * timeinfo;

-	scoresFile = fopen("BrogueHighScores.txt", "r");
+	scoresFile = fopen("HOMEBREW_PREFIX/var/brogue/BrogueHighScores.txt", "r");

 	if (scoresFile == NULL) {
 		initScores();
-		scoresFile = fopen("BrogueHighScores.txt", "r");
+		scoresFile = fopen("HOMEBREW_PREFIX/var/brogue/BrogueHighScores.txt", "r");
 	}

 	for (i=0; i<HIGH_SCORES_COUNT; i++) {
@@ -197,7 +197,7 @@
 	short i;
 	FILE *scoresFile;

-	scoresFile = fopen("BrogueHighScores.txt", "w");
+	scoresFile = fopen("HOMEBREW_PREFIX/var/brogue/BrogueHighScores.txt", "w");

 	for (i=0; i<HIGH_SCORES_COUNT; i++) {
 		// save the entry

