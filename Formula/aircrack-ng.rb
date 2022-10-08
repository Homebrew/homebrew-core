class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"
  url "https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz"
  sha256 "05a704e3c8f7792a17315080a21214a4448fd2452c1b0dd5226a3a55f90b58c3"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause", "OpenSSL"]
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?aircrack-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_monterey: "499ece5ad3317410df74ec2ca4de39e198a7739d0be0e6f0a48042a684631f73"
    sha256                               arm64_big_sur:  "68528c46fdf173d9a8a02c27b39c7d57d19ac87bca2c98e4dd6b3ec11745b470"
    sha256                               monterey:       "049eedde2f5028350063d74a8fcf406b743ec6c53d019a183f74a27d5f9fc586"
    sha256                               big_sur:        "21e3668b005f69b9b05acee557079e01abf9dbdd4c7c36ca3da102e266bc4654"
    sha256                               catalina:       "993529dff2b7b3143497fb057ecdab91a4562830451b6fd4414fd84ae7c9c96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23cb441fb4fdef1d74fc2edea0a7a601bb4834f5c2b0f56176c4095a2fc2135"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
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
                           "--sysconfdir=#{etc}",
                           "--with-experimental"
    system "make", "install"
    inreplace sbin/"airodump-ng-oui-update", "/usr/local", HOMEBREW_PREFIX
  end

  def post_install
    pkgetc.mkpath
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
