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
    sha256                               arm64_monterey: "06f4f523f3117c4f9c4e3f3a34c6f88f9483bea0d381c680569eabbb8acf3ec2"
    sha256                               arm64_big_sur:  "e62728054eaaf86fd66be04eb6a058f5ec0d83711b5b789a106e0c42a03455a8"
    sha256                               monterey:       "2c73ae3414b8b586769134e08950beb8d1c00e05074c3169d813400bc3696088"
    sha256                               big_sur:        "8a131a99a89edd127981b9dc2c91df91ba7a03b7c0d6c74521392e1649fa7d09"
    sha256                               catalina:       "1b5ecf42ef840c108536eac5107cf63c514ca2f3d7e8c4f32e5b301f088729c1"
    sha256                               mojave:         "e6bbba9c16ac26aaacaad5ac4935100a79cf702ab8fcb35fa9797e806ec003fe"
    sha256                               high_sierra:    "fad333ea8e2792d88305c22b62549f63900ea32aa3f856de57d6e8d70740cd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d6c32f3dc5f82c6a897a4a5916c70f686ce40c3aeaf7585e8d449ef971a9d4a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "sqlite"

  uses_from_macos "libpcap"

  # Fix build for Apple Silicon.
  # TODO: Remove in the next release
  if Hardware::CPU.arm?
    patch do
      url "https://github.com/aircrack-ng/aircrack-ng/commit/a4cdb89cae06545d547a6c15a5a92f7972fad38d.patch?full_index=1"
      sha256 "63ebf16f510533c94a3a1922fe09a98957da337bbb6988887349f5fe17d4ca6c"
    end

    patch do
      url "https://github.com/aircrack-ng/aircrack-ng/commit/00fd71f1fe8e5451cfff3210f2b401eddc2d5fbd.patch?full_index=1"
      sha256 "b5ac52c4c4574c470118151c0737bbd06c0f7af38f65e90d40c0a14bfb08477d"
    end

    patch do
      url "https://github.com/aircrack-ng/aircrack-ng/commit/aab7db82306a3da43f75dd6adad7909f08f795c5.patch?full_index=1"
      sha256 "eda226f147b6cc5ded0b0bd21f0a8d061989917da79596a1468b42bd8eaa7f99"
    end

    patch do
      url "https://github.com/aircrack-ng/aircrack-ng/commit/dcf87db21139d56825c1e628c24b84bf2232dcef.patch?full_index=1"
      sha256 "54d21261eadb066fc54eb5ca60717571cc3168a9154bce4b73647637c85c29c9"
    end
  end

  # MacPorts backport of fix for VERSION file conflict with C++20 version header
  # Upstream ref: https://github.com/aircrack-ng/aircrack-ng/commit/35169a66becf48fd014cb5124da3b61b4d25d812
  # TODO: Remove this in next release.
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/fc65d53dc398f8216b837889b3b5e5f41e9b9473/security/aircrack-ng/files/VERSION.patch"
    sha256 "62706ad1814ed28f06ee2dd600c6ae5516f4c57d36439dc37a8fdccddc9738ac"
  end

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    # TODO: Align with VERSION patch. Remove this in next release.
    mv "VERSION", "AC_VERSION"
    mv "VERSION.in", "AC_VERSION.in"

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
    assert_match "usage: aircrack-ng", shell_output("#{bin}/aircrack-ng --help")
    assert_match "Logical CPUs", shell_output("#{bin}/aircrack-ng -u")
    expected_simd = Hardware::CPU.arm? ? "neon" : "sse2"
    assert_match expected_simd, shell_output("#{bin}/aircrack-ng --simd-list")
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
