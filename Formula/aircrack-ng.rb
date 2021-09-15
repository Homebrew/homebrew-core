class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"
  url "https://download.aircrack-ng.org/aircrack-ng-1.6.tar.gz"
  sha256 "4f0bfd486efc6ea7229f7fbc54340ff8b2094a0d73e9f617e0a39f878999a247"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause", "OpenSSL"]

  livecheck do
    url :homepage
    regex(/href=.*?aircrack-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               big_sur:      "8a131a99a89edd127981b9dc2c91df91ba7a03b7c0d6c74521392e1649fa7d09"
    sha256                               catalina:     "1b5ecf42ef840c108536eac5107cf63c514ca2f3d7e8c4f32e5b301f088729c1"
    sha256                               mojave:       "e6bbba9c16ac26aaacaad5ac4935100a79cf702ab8fcb35fa9797e806ec003fe"
    sha256                               high_sierra:  "fad333ea8e2792d88305c22b62549f63900ea32aa3f856de57d6e8d70740cd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2d6c32f3dc5f82c6a897a4a5916c70f686ce40c3aeaf7585e8d449ef971a9d4a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "sqlite"

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    system "./autogen.sh", "--disable-silent-rules",
                           "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--with-experimental"
    system "make", "install"
  end

  def caveats
    <<~EOS
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
@@ -20,25 +20,6 @@ fi

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
-if [ x$USERID = "x" -a x$(id -ru) != "x" ]
-then
-	USERID=$(id -ru)
-fi
-
-if [ x$USERID != "x" -a x$USERID != "x0" ]
-then
-	echo Run it as root ; exit ;
-fi
-
 
 if [ ! -d "${OUI_PATH}" ]; then
 	mkdir -p ${OUI_PATH}
