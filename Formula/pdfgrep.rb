class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.1.0.tar.gz"
  sha256 "c9c16b4816389b20313aebb4fbad86f7775ae03330fcc08c82fa522ed810548d"

  bottle do
    cellar :any
    sha256 "10ba0ae5123e6ceb5d76f2ddda41637128fed56e2e1ec9978287f6b5a84c7290" => :high_sierra
    sha256 "a59d804b0ffcf7fe05ad12c0d6dbd7220e908384fc20ab06de275f75a40008bd" => :sierra
    sha256 "7b5081ffcc3392857f224cc63e90bcc9b94fcf416159d14c2b4bf10812f05f32" => :el_capitan
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
