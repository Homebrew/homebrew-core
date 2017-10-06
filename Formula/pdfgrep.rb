class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.0.1.tar.gz"
  sha256 "0370d744b3072d47383dbed2cb9c8b0b64b83c084da5a8961f8d4bc7669e941e"
  revision 2

  bottle do
    cellar :any
    sha256 "7c764882f9340b01c96e2d2dae8d0993d0efb94d8a21640903fb5cb59878f246" => :high_sierra
    sha256 "9179212402f7f33f08ff9f87a94620b52e1e0a76ae79f038d2b7497e6df0cbd1" => :sierra
    sha256 "f908b51799c4a791fb27e4475b7d6a19d46123ef601f1422c203b4a0dd69c05a" => :el_capitan
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
