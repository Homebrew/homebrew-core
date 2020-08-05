class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.1.2.tar.gz"
  sha256 "0ef3dca1d749323f08112ffe68e6f4eb7bc25f56f90a2e933db477261b082aba"

  bottle do
    cellar :any
    sha256 "575608fb99410f9271656ed1bf051456318cd7bece7ae654d122db930ddbd7b3" => :catalina
    sha256 "4e6828ef5db24086dae00e10c9c18671352303c6e79a2148f62bd9104678ea08" => :mojave
    sha256 "95ffadce5ed5baa82a48c71e1bb8915d080c9e9d4a14e63982945eb543e58b10" => :high_sierra
    sha256 "b004e7801489c6cb0361c5032278d11cafd4ace151a02ee97214c79dba0f89be" => :sierra
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
