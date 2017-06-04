class PhoronixTestSuite < Formula
  desc "Automated testing framework"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://www.phoronix-test-suite.com/releases/phoronix-test-suite-7.0.1.tar.gz"
  sha256 "436d949af604248776d725afb0f4eba6b8f9b1bf134d1f97544baf00e67c9d78"

  bottle do
    cellar :any_skip_relocation
    sha256 "c29c9748f6ba2c76c20a0dedbc96b72d0dc4ccd243506d5752c1f9e42964aece" => :sierra
    sha256 "128720345d82750d788cf4c50d0865d5922041018315633233266cffd6693f02" => :el_capitan
    sha256 "128720345d82750d788cf4c50d0865d5922041018315633233266cffd6693f02" => :yosemite
  end

  patch :DATA

  def install
    system "./install-sh", prefix
    bash_completion.install "./pts-core/static/bash_completion"
  end

  test do
    assert_match "Ringsaker", shell_output("#{bin}/phoronix-test-suite version | grep -v ^$")
  end
end

__END__
diff -ur a/install-sh b/install-sh
--- a/install-sh	2012-01-04 08:43:26.000000000 -0800
+++ b/install-sh	2017-04-13 10:18:17.000000000 -0500
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

 diff -ur a/pts-core/objects/client/pts_client.php b/pts-core/objects/client/pts_client.php
 --- a/pts-core/objects/client/pts_client.php	2017-05-02 18:30:16.000000000 +0200
 +++ b/pts-core/objects/client/pts_client.php	2017-05-02 18:31:53.000000000 +0200
 @@ -803,6 +803,8 @@
	}
	public static function user_agreement_check($command)
	{
 +		return true;
 +
		$pso = pts_storage_object::recover_from_file(PTS_CORE_STORAGE);

		if($pso == false)
