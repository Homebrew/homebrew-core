class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.1.2.tar.gz"
  sha256 "0ef3dca1d749323f08112ffe68e6f4eb7bc25f56f90a2e933db477261b082aba"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "955662644ac2934b8e215b1d40ac2ba75eb76cf00e298d6020bccd5d3cff4c88"
    sha256 cellar: :any,                 arm64_monterey: "a0cbc11de2be8d3bd61a1e4838b723de768059d94a72c92406f26127b040a599"
    sha256 cellar: :any,                 arm64_big_sur:  "76971615597120ebba8f1db8e9c26d70d91faea4b0953c037047eddc9dbeb878"
    sha256 cellar: :any,                 ventura:        "536be42f4b67ca15c0707ca53168d74f6bc77f4eeb40bdee2920f5f8d1b2f87f"
    sha256 cellar: :any,                 monterey:       "934fedb57e6a7d731d93c0aa43dda0cdb02efb0e35822dc09dc1ce751c965166"
    sha256 cellar: :any,                 big_sur:        "29cd70f30111aecafd88eb0281319f19415183b6a30393d32e145e2121b91a91"
    sha256 cellar: :any,                 catalina:       "c1da1cf263fdba46a66396b2b31fd970c8299f538064a4341ba4045d36c4c082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "003b4df43510e3ee5e4d07092e43c67f525d4cb0a61389dac3d4b0dae1010ff2"
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

  fails_with gcc: "5"

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
