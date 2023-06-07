class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  # Homepage has an expired SSL cert as of 16/12/2020, so we add a Debian mirror
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.1738.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.1738.orig.tar.gz"
  sha256 "1033bc90621896ef6145df448b48fdfa342dbdf01b48fd9ae8acf64f6a31b92a"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]
  revision 2

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "32425d6e5b0c6416d7ab329ed601cee615050d8699ac11ddc2c44d925447ab3f"
    sha256 arm64_monterey: "172117c0132e32a8f25f638dc4e6493ecd681578ff92b2ed2b4f484bfbd812c7"
    sha256 arm64_big_sur:  "e75eea16b4779c1942467bd53e2b75366618607d8483c2e46c95e3f58c99fc62"
    sha256 ventura:        "ff8e710e23b24d0b361a7a75c0b9dd0b8581d1282972ba28891db5207acc673e"
    sha256 monterey:       "bb437a3b2067048810ae0b15bb51ed9b074f10d0df484918aa2e026f119643be"
    sha256 big_sur:        "e87462cd26301aef297902f8145f2a79bbcf91ac3bd84cd422d2bf7f6d81e836"
    sha256 x86_64_linux:   "313806086e8357bd20ecd3d6afebc93108087c2fcea40c527cdf5388c7970be1"
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
