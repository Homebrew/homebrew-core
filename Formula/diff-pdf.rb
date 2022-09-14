class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "78ab605c8c34bcef91f31e9fdef602a0d1367737abb98a8daddf6d6b7aa30671"
    sha256 cellar: :any,                 arm64_big_sur:  "96eb85ddbde92e463f88b79be4eb25cca96e07ef0723760b40b37d99eb00523f"
    sha256 cellar: :any,                 monterey:       "87f787670ab2c9363068bed98bfa62308eeb83740186500cf79426ee0a14bbb8"
    sha256 cellar: :any,                 big_sur:        "0624106a508ec4d7b568f0c6bc7e35f9d53a2fc8b85d2716b81f3ce4ae0508a2"
    sha256 cellar: :any,                 catalina:       "19fb6b885deeeb0af2a85de372178cb076fa32299408cfecde57f8489093e38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab5dc28211c67d3ade744008798834b0dda2099f34d8a0cfca89cd3fed034e83"
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
