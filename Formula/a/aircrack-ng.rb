class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"
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
    rebuild 2
    sha256                               arm64_tahoe:   "dfe73bf5765f920026fce1001ddd0ed9febf365f91f32d4e8f28f70b469716ff"
    sha256                               arm64_sequoia: "3d5953610f1bc220d0780c7b1d47b1a95b0cdfd702a08862eec388b9031b9845"
    sha256                               arm64_sonoma:  "511f7dc5330c2bcf5d5928aeead9eedac501d3864c1db05bd0f68dafc8a414ea"
    sha256                               sonoma:        "a550e9d1a135c2845433ff4cbbca48b1744688679f45e6ca9d0f6d139a4a8c3f"
    sha256                               arm64_linux:   "a2a0d2ee105376e50383c4cc2b7edd45847ddcb95524d8720ea2b316d4ee5a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546f002883a4dbf8405b9fcf82b73bceea7dd5ef61b318b4fa0f4c3e4764a1a6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  # Backport support for PCRE2
  patch do
    url "https://github.com/aircrack-ng/aircrack-ng/commit/adbb91bbec99b8c12924966314714a26ec86f504.patch?full_index=1"
    sha256 "b3b4eae6987f1a0a812f30426b7ceb77cd50da958c05415840291f69cbe005d6"
  end
  patch do
    url "https://github.com/aircrack-ng/aircrack-ng/commit/88408f6441a1527b6e7e55ab5bccd113cfad4156.patch?full_index=1"
    sha256 "fe162569841b0f101759e019ba2034e7370555c2bea7b2b9113c70910708b062"
  end
  patch do
    url "https://github.com/aircrack-ng/aircrack-ng/commit/f7d65bdbdd83ba8ae4ea0f145939da7a5a2fb0d1.patch?full_index=1"
    sha256 "98a675f0bca1fc7a8e85b8ac67f1a0e554aae824679b849b0e41f77d2d84a69f"
  end

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
