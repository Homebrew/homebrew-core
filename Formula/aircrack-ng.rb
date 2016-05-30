class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"

  # If you compile aircrack-ng from source using Gmake, it is compatible with OS X
  # Issue fixed by compiling aircrack-ng from source
  url "http://download.aircrack-ng.org/aircrack-ng-1.2-rc4.tar.gz"
  sha256 "d93ac16aade5b4d37ab8cdf6ce4b855835096ccf83deb65ffdeff6d666eaff36"

  bottle do
    cellar :any
    sha256 "cb70cfa6efceada012445e9bf0300050207dc59572edc5e58795c9035e14dc43" => :el_capitan
    sha256 "97fd0debe4e17e143facd4fa4483d7813c3edc328acd366a72d3fda29d7a6c7b" => :yosemite
    sha256 "02efed81e48c8f70bbd1d3051e84b25815fcceb7166cb79d472f9552a4708ae2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "openssl"
  depends_on "pcre"

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    system "make", "xcode=true", "sqlite=true", "experimental=true", "pcre=true"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  def caveats; <<-EOS.undent
    Run `airodump-ng-oui-update` install or update the Airodump-ng OUI file.
    EOS
  end

  test do
    system "#{bin}/aircrack-ng", "--help"
  end
end

__END__
--- a/scripts/airodump-ng-oui-update
+++ b/scripts/airodump-ng-oui-update
@@ -7,25 +7,6 @@
 OUI_PATH="/usr/local/etc/aircrack-ng"
 AIRODUMP_NG_OUI="${OUI_PATH}/airodump-ng-oui.txt"
 OUI_IEEE="${OUI_PATH}/oui.txt"
-USERID=""
-
-
-# Make sure the user is root
-if [ x"`which id 2> /dev/null`" != "x" ]
-then
-	USERID="`id -u 2> /dev/null`"
-fi
-
-if [ x$USERID = "x" -a x$UID != "x" ]
-then
-	USERID=$UID
-fi
-
-if [ x$USERID != "x" -a x$USERID != "x0" ]
-then
-	echo Run it as root ; exit ;
-fi
-

 if [ ! -d "${OUI_PATH}" ]; then
   mkdir -p ${OUI_PATH}
