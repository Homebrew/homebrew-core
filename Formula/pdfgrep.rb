class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.0.tar.gz"
  sha256 "2636da1f3157722640170f4469b574835b1c834c71237a4c3ca00197e31a89b4"

  bottle do
    cellar :any
    sha256 "a871c41a2a76055e7f00bdc09c1beba86f67d1d766d16e6dcab38229eb1daaf3" => :sierra
    sha256 "86dfa0e1e5efaa4e9f760af79061d81e949fea4ceaa7922649f6ae9e030e73f0" => :el_capitan
    sha256 "d2c6c7b50c616c4efd85699ea2f8f4b88dde03205bdf13920dc8bb8fb059d617" => :yosemite
  end

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "poppler"
  depends_on "pcre" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "./autogen.sh" if build.head?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--without-libpcre" if build.without? "pcre"
    system "./configure", *args

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"pdfgrep", "-i", "homebrew", test_fixtures("test.pdf")
  end
end
