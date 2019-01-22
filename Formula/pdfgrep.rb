class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.1.1.tar.gz"
  sha256 "2c8155f30fe5d9d8ec4340e48133ed0b241496bbebe29498931f975c67a10c0b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8a2080298573474a970fa42308b89be7447f51f6a21561b211fae068a71fde8c" => :mojave
    sha256 "53370681817861c0931eef6b49eab6e39d63413ba0554e588aec05906613e6c0" => :high_sierra
    sha256 "4e4683d4dbf9db612c81abf7db0c9a36f741e973432b2b8d743ac58dbec1404f" => :sierra
  end

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "pcre"
  depends_on "poppler"

  needs :cxx11

  def install
    ENV.cxx11
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"pdfgrep", "-i", "homebrew", test_fixtures("test.pdf")
  end
end
