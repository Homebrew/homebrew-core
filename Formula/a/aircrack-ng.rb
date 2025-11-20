class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"
  # TODO: Migrate to PCRE2 in the next release
  url "https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz"
  sha256 "05a704e3c8f7792a17315080a21214a4448fd2452c1b0dd5226a3a55f90b58c3"
  license all_of: [
    "BSD-3-Clause", # include/aircrack-ng/third-party/{if_arp.h,if_llc.h}
    "GPL-2.0-or-later",
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
  ]
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?aircrack-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "bd47fe70e67083f0734ca6a354153b77747cdba142667a57331d3b7858ba7644"
    sha256                               arm64_sequoia: "281776f2660cd82671618dde4826445942dbebcb52ae0a36acaa1fe78ee55661"
    sha256                               arm64_sonoma:  "d264d1232090cbd350f4080c57b8541e4c3b7fc9a397b217bf689a0de023fe91"
    sha256                               sonoma:        "56b22a9406e0ec31495f70f2a693e69c0a9f9466912f5a1947bf85477f7b5f0f"
    sha256                               arm64_linux:   "80d591bf71824b4effad6d1d3804e74b6e7fdc1228dafe4ce153c623b8529796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681e9f90551413b40165d371137ee3271866a761e31d467872dc582dfbe8821e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "sqlite"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    system "./autogen.sh", "--disable-silent-rules",
                           "--sysconfdir=#{etc}",
                           "--with-experimental",
                           *std_configure_args
    system "make", "install"
    inreplace sbin/"airodump-ng-oui-update", "/usr/local", HOMEBREW_PREFIX
    pkgetc.mkpath
  end

  def caveats
    "Run `airodump-ng-oui-update` install or update the Airodump-ng OUI file."
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
