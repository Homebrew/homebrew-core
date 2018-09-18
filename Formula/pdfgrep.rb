class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.1.1.tar.gz"
  sha256 "2c8155f30fe5d9d8ec4340e48133ed0b241496bbebe29498931f975c67a10c0b"

  bottle do
    cellar :any
    sha256 "d60488a632255a11357beea91d489bbb707d883cd549140ffdb2b1f8abe193dc" => :mojave
    sha256 "164e7937ccf496ae35b3abbb5f7718a09428a25b9d67b7d6e35f7f6a55e06ac7" => :high_sierra
    sha256 "99b80991db034c80573ab2153c831b9feccf535ca453ce3ffa770561e91e95b2" => :sierra
    sha256 "633b29af2386f3feaf857ba3cd44258c614295c0b49f32ed95292abfb1c434b2" => :el_capitan
  end

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
