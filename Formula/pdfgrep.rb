class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.1.1.tar.gz"
  sha256 "2c8155f30fe5d9d8ec4340e48133ed0b241496bbebe29498931f975c67a10c0b"

  bottle do
    cellar :any
    sha256 "d8d121fd770825ebd23ae5e6ed433f5362c20aee6c6138c3f173a529ccb30c93" => :high_sierra
    sha256 "da7b01c7ca4b63dbb4f028b6e6c8e607c26c78717aed895636ee8dee59ff9a20" => :sierra
    sha256 "5f22fcfc3b6a85433d7ac85b0e8b74c25bf34daef8ca39b7cc117656239fa4b3" => :el_capitan
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
