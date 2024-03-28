class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.2.0.tar.gz"
  sha256 "0661e531e4c0ef097959aa1c9773796585db39c72c84a02ff87d2c3637c620cb"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0762f91b0ca5ad841b06af3bf2203fe9acd86a0f8e19847d1c33c3d461184cd"
    sha256 cellar: :any,                 arm64_ventura:  "02a024177be543d2744302ea206c3ba02ffeb87a84c8e8e26f66a1847c0b84c9"
    sha256 cellar: :any,                 arm64_monterey: "ff8abcf9a428a1a30b177dc2cb61fce86ad3832a1f4ebb7d328c673f4ec3a6c4"
    sha256 cellar: :any,                 sonoma:         "4bb38a435fdbd3054fc17ef953d3d1af7d9b667c021ed50522e2eb0e259cf21d"
    sha256 cellar: :any,                 ventura:        "b101752d7babcffe86816fe6ea2d153e73b55150b1b7dc3348f05129b785012c"
    sha256 cellar: :any,                 monterey:       "9d20ab009e555a217357e45ba7289a4869264e867daebe4f622bd9ffd5ea21ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1cf1566232f3a00551158c128251dbaeefa86008f83c6e7ce3191eec5929910"
  end

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "pcre" # PCRE2 issue: https://gitlab.com/pdfgrep/pdfgrep/-/issues/58
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
