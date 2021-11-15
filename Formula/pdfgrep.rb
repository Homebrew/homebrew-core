class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.1.2.tar.gz"
  sha256 "0ef3dca1d749323f08112ffe68e6f4eb7bc25f56f90a2e933db477261b082aba"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "adfcd59692904387134b794317ee336369046ff154611b58b7f2a766ed84e406"
    sha256 cellar: :any,                 arm64_big_sur:  "b4bf22a5e3b55fe230c32a72d6d58ff8ba432b976dd74c189999fe0308d49f19"
    sha256 cellar: :any,                 monterey:       "cc197e6420090feed9a97f021642994beabb47feff2f87a6c172bdf53583983b"
    sha256 cellar: :any,                 big_sur:        "626dcfe4a770d5fee8498dcc58aaa5152a4532c06a707b37d81076e6cd4b9ced"
    sha256 cellar: :any,                 catalina:       "536c672e1e8cad042b151f9d82143b71019aedfea23ab3d34df1c7844fa9e568"
    sha256 cellar: :any,                 mojave:         "f65e1a759163e3f50429241577b54fefc1b0640369129820979301156883e86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca757c071733afdc7b4b791d2fc81a87f48e599cb82e72dec3ea64dd0b458f27"
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

  on_linux do
    depends_on "gcc"
  end

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
