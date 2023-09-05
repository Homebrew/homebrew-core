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
    sha256                               arm64_ventura:  "d3d59c186fb570afbf6c925fece858ae01ed7d0a7290e3cccbd45a1ae3789881"
    sha256                               arm64_monterey: "ae0d6fe850335049e70c0eed7486182be424fe7e9f1f449687ab2a4248e0816a"
    sha256                               arm64_big_sur:  "146f8023328aff76b469874b408e00a2bb142e05753badd291be1e0370a21502"
    sha256                               ventura:        "f418df11db6bc8af148f4f889715009da8e7084fb2777c3831f38cd5a90a3c4a"
    sha256                               monterey:       "32bab474db5a9602788ffd7d32f4bd25199732705cc4856b7335c96d6675a961"
    sha256                               big_sur:        "c7b4666859d336a5219c53d5b9310547495438e460d38c7f1b3175c274245b55"
    sha256                               catalina:       "09115822ebac9a6d9903635faa0a393dc1bcaaaf2fcbb344a5dee123fe1f02f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72556b434c07c994c66ac4f37b9946884357af00a7543d6e961808ca78a6818c"
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
