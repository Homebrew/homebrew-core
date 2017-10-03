class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.0.1.tar.gz"
  sha256 "0370d744b3072d47383dbed2cb9c8b0b64b83c084da5a8961f8d4bc7669e941e"
  revision 1

  bottle do
    cellar :any
    sha256 "c4330b1a7690b60b55d8c902c14358dc0f9bcd6d2d87a88116774d641e068087" => :high_sierra
    sha256 "437f7358c233ef85a5da4cb63e5fd2c52491e205d5f99e923d3990cc5b392472" => :sierra
    sha256 "1d33d1ca60f3c3e6f5d1ca4dd2da60c74b5bb6da23893e781ac0e0ff410b4a76" => :el_capitan
    sha256 "75571a3febcfdd90c09ca15f019df8e7dd37fec5476280b29ea095fac095e395" => :yosemite
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
