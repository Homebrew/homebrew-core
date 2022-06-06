class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "83766e8b62534bbec80b603d08c56be97548fa1c67200565300b148466a4f2e7"
    sha256 cellar: :any,                 arm64_big_sur:  "6d52ffd8c73772030febeaccbce369e4ebd3aa8f5d48ecaebc871fd209bd8281"
    sha256 cellar: :any,                 monterey:       "62c63cea4828d2cee726103208f3ce6059fc9032b895e6f10462895fd475e007"
    sha256 cellar: :any,                 big_sur:        "930be3aca2edfcffd9d6e77bb8b11e02569efb34f36721038b23e498755aa315"
    sha256 cellar: :any,                 catalina:       "98fc9b5ebbeacf9d27d1d06c6b4d1e401ba15eea9e2d155674a95f450c72b61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce2184b6f83a05827d1fe7623fb37f5241d370c37b01084a22e2e2dd6a95ee5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxwidgets"

  on_linux do
    depends_on "gcc"
  end

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
