class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a0977dfd009954ba4428e60a954efa92eaa3202eb2061e6a60aaa3c16faf2fc4"
    sha256 cellar: :any,                 arm64_monterey: "0616440421b45bca4494c5eaf90640d61b4f70ef77fb4a811fcebda766f07957"
    sha256 cellar: :any,                 arm64_big_sur:  "0e01c107b0949a6d3baeefaf15899461a8b7ac886efdba9d2960a52a3e62d59a"
    sha256 cellar: :any,                 ventura:        "234055d5afe5c54ac619aa3a14d802507fa771d3f6c9cf8856f1ddcb7e937c4e"
    sha256 cellar: :any,                 monterey:       "439c5722731ba71ccff2e07de2c7b38262c47f8532c9949f606e9e12419682ea"
    sha256 cellar: :any,                 big_sur:        "2e11ac7650d5cfe77922aa0deb7c036b708d370e5c748688b1538bfe3606ca54"
    sha256 cellar: :any,                 catalina:       "aa5bfc82668e41fb44c6a5ed7e83b9c1a59ecd7ce4c76a67530713767e95902f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3b271e5a61d685e2fd6357b90e62f4849daae2de3759f58aa9a85563b3d4e94"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxwidgets"

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system "#{bin}/diff-pdf", "--output-diff=no_diff.pdf", testpdf, testpdf
    assert (testpath/"no_diff.pdf").file?
  end
end
