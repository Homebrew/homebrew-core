class PhoronixTestSuite < Formula
  desc "Automated testing framework"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://www.phoronix-test-suite.com/releases/phoronix-test-suite-7.0.1.tar.gz"
  sha256 "436d949af604248776d725afb0f4eba6b8f9b1bf134d1f97544baf00e67c9d78"

  bottle do
    cellar :any_skip_relocation
    sha256 "726f227d374a8f18c33a2200f1764023af7255232390b5a66356644789707e76" => :sierra
    sha256 "2821b90bee0c1b736fc7bbf2ddff811f4e0501483ad9958a034a00354c4dc18c" => :el_capitan
    sha256 "992866a9deb933c96c8863efeba613acf2176ce027f82c89de71c050246d2e89" => :yosemite
    sha256 "b1387c352b9fdc9153ce6fac4c8022486370611e2dc62079698d8f7ea635d099" => :mavericks
  end

  patch :DATA

  def install
    system "./install-sh", prefix
  end

  test do
    assert_match "Ringsaker", "#{bin}/phoronix-test-suite version | grep -v ^$ | sed 's/.*(\(.*\))/\1/'"
  end
end


__END__
--- a/install-sh	2012-01-04 08:43:26.000000000 -0800
+++ b/install-sh	2017-04-13 10:18:17.000000000 -0500
@@ -56,4 +56,4 @@
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
-mkdir -p $DESTDIR$INSTALL_PREFIX/../etc/bash_completion.d/
+mkdir -p $DESTDIR$INSTALL_PREFIX/etc/bash_completion.d/

@@ -72,4 +72,4 @@
 cp documentation/man-pages/*.1 $DESTDIR$INSTALL_PREFIX/share/man/man1/
-cp pts-core/static/bash_completion $DESTDIR$INSTALL_PREFIX/../etc/bash_completion.d/phoronix-test-suite
+cp pts-core/static/bash_completion $DESTDIR$INSTALL_PREFIX/etc/bash_completion.d/phoronix-test-suite.bash
 cp pts-core/static/images/phoronix-test-suite.png $DESTDIR$INSTALL_PREFIX/share/icons/hicolor/48x48/apps/phoronix-test-suite.png

@@ -99,6 +99,6 @@
 # sed 's:\$url = PTS_PATH . \"documentation\/index.html\";:\$url = \"'"$INSTALL_PREFIX"'\/share\/doc\/packages\/phoronix-test-suite\/index.html\";:g' pts-core/commands/gui_gtk.php > $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/pts-core/commands/gui_gtk.php

 # XDG MIME OpenBenchmarking support
-if [ "X$DESTDIR" = "X" ] && which xdg-mime >/dev/null && which xdg-icon-resource >/dev/null
+if [ "X$INSTALL_PREFIX" = "X" ] && which xdg-mime >/dev/null && which xdg-icon-resource >/dev/null
 then

@@ -114,7 +114,7 @@
 fi

-echo -e "\nPhoronix Test Suite Installation Completed\n
+echo "\nPhoronix Test Suite Installation Completed\n
 Executable File: $INSTALL_PREFIX/bin/phoronix-test-suite
 Documentation: $INSTALL_PREFIX/share/doc/phoronix-test-suite/
 Phoronix Test Suite Files: $INSTALL_PREFIX/share/phoronix-test-suite/\n"
