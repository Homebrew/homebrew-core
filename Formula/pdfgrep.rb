class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.1.2.tar.gz"
  sha256 "0ef3dca1d749323f08112ffe68e6f4eb7bc25f56f90a2e933db477261b082aba"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "b7260612ff09a200376d68241d4cb99a396b2be3fcc5820dd3600e1acb067c16" => :big_sur
    sha256 "94f4fd04704afb89692d9b9a187e2d2e01e17ef272c0852be55e8db64227021f" => :arm64_big_sur
    sha256 "0b1ba715232cf515e73c09a988fb3fed2e645ef478645dda96bcc19a86d7f1ef" => :catalina
    sha256 "a34785b9b7b1cffd728cf48efe6ce7281fed47db331f0bea36fc8fd016ac8fa2" => :mojave
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
