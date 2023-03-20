class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  # Homepage has an expired SSL cert as of 16/12/2020, so we add a Debian mirror
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.1738.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.1738.orig.tar.gz"
  sha256 "1033bc90621896ef6145df448b48fdfa342dbdf01b48fd9ae8acf64f6a31b92a"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]
  revision 1

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "031ee62b11a955552b030373aa91497be82b7b7fee22ce3c60cc24b1918e88c1"
    sha256 arm64_monterey: "2a53a923852149cd694ce6d7be8b45c0403d8d03a0766f4f322fadc7e8f71bf7"
    sha256 arm64_big_sur:  "878b3ea7543e92619a780924ad4d658a4d02c130c574c6a663fa538b520ec0b5"
    sha256 ventura:        "ecaac78aa7f662a1622d736cff67eeaca243a2bd21df149902c9b215c0ee76af"
    sha256 monterey:       "ea888dfb5125f9bd5bbbc67d435072067cd37b965a083b0734e060945e409715"
    sha256 big_sur:        "c58188256a4bb81c01c63da5dfa60ba65496d5a4e9b6b21b40d7614930bb916e"
    sha256 x86_64_linux:   "45a3daec18716e556c84641e255863a690f4affa90134a535430d141c0fc865d"
  end

  depends_on "gettext"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "nettle"
  depends_on "pcre"
  depends_on "webp"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "libnsl"
  end

  def install
    ENV.append "CFLAGS", "-m64"
    ENV.deparallelize

    # Workaround for https://git.lysator.liu.se/pikelang/pike/-/issues/10058
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    # Use GNU sed on macOS to avoid this build failure:
    # sed: RE error: illegal byte sequence
    # Reported upstream here: https://git.lysator.liu.se/pikelang/pike/-/issues/10082.
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    configure_args = %W[
      --prefix=#{libexec}
      --with-abi=64
      --without-bundles
      --without-freetype
      --without-gdbm
      --without-odbc
    ]

    system "make", "CONFIGUREARGS=#{configure_args.join(" ")}"
    system "make", "install", "INSTALLARGS=--traditional"

    bin.install_symlink libexec/"bin/pike"
    man1.install_symlink libexec/"share/man/man1/pike.1"
  end

  test do
    path = testpath/"test.pike"
    path.write <<~EOS
      int main() {
        for (int i=0; i<10; i++) { write("%d", i); }
        return 0;
      }
    EOS

    assert_equal "0123456789", shell_output("#{bin}/pike #{path}").strip
  end
end
