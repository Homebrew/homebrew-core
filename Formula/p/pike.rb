class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  # Homepage has an expired SSL cert as of 16/12/2020, so we add a Debian mirror
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.1738.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.1738.orig.tar.gz"
  sha256 "1033bc90621896ef6145df448b48fdfa342dbdf01b48fd9ae8acf64f6a31b92a"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]
  revision 3

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "68afe655f82c2d097fefafb82f5133063d1afe41d14b22552142e55cae905052"
    sha256 arm64_sonoma:   "70b0fbdddedbb800cb84877cc859c3f877809937e372ce220d7b01d0526948c7"
    sha256 arm64_ventura:  "6e208572c05918a3f7b848e774ca2399c513e1f5f016f3c6c6af4d28f1000080"
    sha256 arm64_monterey: "92ed5696e91b3f72bdc57a1558857113d166deb19688442518f3c26f9e2e435a"
    sha256 arm64_big_sur:  "55028a48c997c3e6399e3ce633da298bacc06ae82dd1ab261c98f172b53a0a56"
    sha256 sonoma:         "1d092bdeb415eb24ee82bcf2fa2fc8aef38c9c5150bfbbacc95227fd9c8abca9"
    sha256 ventura:        "f5a49dab05cd49eb2ccd647db2d3542a6247e50b3eaa45b91d009cf09f9e727e"
    sha256 monterey:       "5c353c23f7cd2ef2439d32016731c8f690c735cdd3bddbb090d8d53d4f9dda95"
    sha256 big_sur:        "4643553b9b42d673a76e20e7b5250713f31e854b4214ac1b5343a3e20547fbe2"
    sha256 x86_64_linux:   "3dd2a451eee2f35622d5c597460841efef2429a8569a07bfa520377a45dd2d83"
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

    # Fix compile with newer Clang
    # https://git.lysator.liu.se/pikelang/pike/-/issues/10058
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
