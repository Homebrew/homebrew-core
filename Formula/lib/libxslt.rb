class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.38.tar.xz"
  sha256 "1f32450425819a09acaff2ab7a5a7f8a2ec7956e505d7beeb45e843d0e1ecab1"
  license "X11"
  revision 1

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc6544dbba1492f85ff365e022f509e5b90cf1eefd718b741e80389c33050de5"
    sha256 cellar: :any,                 arm64_ventura:  "35d88548858fbda1b24792cd42c06393cac959deead4dc75dce6da512b1148a1"
    sha256 cellar: :any,                 arm64_monterey: "c0d279287ad596dc0f645c26a2395122dcc11d2ade608b6f5550ab8cbac5fafd"
    sha256 cellar: :any,                 arm64_big_sur:  "0e787304a2bbc5159bdd73eee1a10eb5f72bad6ffb7adc2d3a13548e680c0107"
    sha256 cellar: :any,                 sonoma:         "4719a37904a229ce1d78f0c7f761d72a775f9177be9976134b766c22f9d1b421"
    sha256 cellar: :any,                 ventura:        "607d4cb7bbbad12f0b2008ee1f696881335ea1560f02b559b2dae8ad3a895437"
    sha256 cellar: :any,                 monterey:       "5b000778f50c467c9f28e882ef5b3e0c9711d8c4e42083f59d0e5bd716127c44"
    sha256 cellar: :any,                 big_sur:        "bd8e4f4cb5883bee9cdc2aeab754a679b9166a2f80f2ec013b7f3bcd9b395387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32f5991ea5c42e4f76e859e4ba4406da9183e621dd09bc0c955be5fe865b7df9"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "icu4c"
  depends_on "libgcrypt"
  depends_on "libxml2"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    libxml2 = Formula["libxml2"]
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-crypto",
                          "--with-libxml-prefix=#{libxml2.opt_prefix}"
    system "make"
    system "make", "install"
    inreplace [bin/"xslt-config", lib/"xsltConf.sh"], libxml2.prefix.realpath, libxml2.opt_prefix
  end

  def caveats
    <<~EOS
      To allow the nokogiri gem to link against this libxslt run:
        gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
    (testpath/"test.c").write <<~EOS
      #include <libexslt/exslt.h>
      int main(int argc, char *argv[]) {
        exsltCryptoRegister();
        return 0;
      }
    EOS
    flags = shell_output("#{bin}/xslt-config --cflags --libs").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-lexslt"
    system "./test"
  end
end
