class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1a8643c9b3c96ce72d46ba82acb0fa764dc930fced4b3172a42d3578019f775d"
    sha256 cellar: :any, big_sur:       "392a18bee5ad1cac37e7ab20fa1c012cc29833d9f8809706fde26d398208c5a7"
    sha256 cellar: :any, catalina:      "a9a6fd8505c8eae372b8ea9bec2a69c97daaa966cd82e7e27fdcbbe27d2f82be"
    sha256 cellar: :any, mojave:        "bf124415504f5f60524b85f5ae8e1c13095afdad0bd483493c6f2af6f3c9470e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxwidgets"

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
