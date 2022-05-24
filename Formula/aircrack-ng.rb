class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"
  url "https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz"
  sha256 "05a704e3c8f7792a17315080a21214a4448fd2452c1b0dd5226a3a55f90b58c3"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause", "OpenSSL"]

  livecheck do
    url :homepage
    regex(/href=.*?aircrack-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_monterey: "45d34208031dc87ff03170ee9e19283d4396f1401fe23583e941b0e4d387bf4d"
    sha256                               arm64_big_sur:  "ff3f2aa5b96ec3ea0436902af935dd2ee7205e51d662dad533637a9ef46839f5"
    sha256                               monterey:       "055bd444a3db202d8b4a9ae173da38dd0a73ea452f3f8e4da5d506ce1c22b398"
    sha256                               big_sur:        "a9e6d77b2d2111c983132147e603eddd609862550c70a978a853aeebc5204dc2"
    sha256                               catalina:       "cd18023bc703b25b20ec00c90920a4c6d73613fe7cb9c390b8ce27fb02e33c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "293d08618fc4a53a180af1357c01053f50ac3aac71417f2ed4ed602fae36ffa3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "sqlite"

  uses_from_macos "libpcap"

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
