class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.0.1.tar.gz"
  sha256 "0370d744b3072d47383dbed2cb9c8b0b64b83c084da5a8961f8d4bc7669e941e"
  revision 2

  bottle do
    cellar :any
    sha256 "0873df814e1b896293b34fd31ef0d2428baf4c0d40f32c75dc6bdc1a4dd26bf0" => :high_sierra
    sha256 "aa16e8cdc5729e82525f972bdc26bb563d347d5afa4fa18ab2409a8acba625f2" => :sierra
    sha256 "d72885d69d7cb69270d78ccf163e2040b2d695ecf1b8f8b82824d5207b88b8a2" => :el_capitan
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
