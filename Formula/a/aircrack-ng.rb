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
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?aircrack-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "79663b102bfc2f2c70886c84e262cb77814c6138b87e26fa722cfa3e460eeb14"
    sha256                               arm64_sequoia: "f60653d0f5b9b9f0db0a83aa34198d89f1a33239ce025fec8a723f5c0d1dff53"
    sha256                               arm64_sonoma:  "a69ff428aa1336b3cee2ca71431e198abb038d60a715927af3123a0e995bfbe8"
    sha256                               sonoma:        "9b8730410869255d5872b50ae285849c706a6540b625b5adea88ee855c450961"
    sha256                               arm64_linux:   "ed587ea52be90ca308c2a598b6f0ade096d05d070a0096b623f0465e7ad50cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0b981f61d925712e4296374229cde3f819aeb38f957d17a37c1500fea1ce8d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
