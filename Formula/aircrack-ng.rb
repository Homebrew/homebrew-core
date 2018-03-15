class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"

  # We can't update this due to linux-only dependencies in >1.1.
  # See https://github.com/Homebrew/homebrew/issues/29450
  url "https://download.aircrack-ng.org/aircrack-ng-1.1.tar.gz"
  sha256 "b136b549b7d2a2751c21793100075ea43b28de9af4c1969508bb95bcc92224ad"
  revision 2

  bottle do
    rebuild 1
    sha256 "1330c445bb9560fccc182c8a129cc3999830d5ce9e988bad60b45b43f869be61" => :high_sierra
    sha256 "07d79311d1480e5fb22c9fc17dbbf9758f02871a518bb3bbc3158a712f2abe9f" => :sierra
    sha256 "bc1052e5690192346ffe097cf08292dec9f61293e1e928bfcdb485ca71c130d6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "openssl"

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    # Fix incorrect OUI url
    inreplace "scripts/airodump-ng-oui-update",
      "http://standards.ieee.org/regauth/oui/oui.txt",
      "http://standards-oui.ieee.org/oui.txt"

    system "make", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  def caveats; <<~EOS
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

