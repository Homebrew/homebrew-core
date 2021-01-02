class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  license "GPL-2.0-only"
  revision 10

  bottle do
    cellar :any
    sha256 "4674469aa1ae2b8d69ca18c68c48c5d498b61d3281bd993619aef4a92d0374d2" => :big_sur
    sha256 "d4fa7e1f8a275e267966f42fdbbd375c1585189ab956e39ee94bc28affee7c92" => :arm64_big_sur
    sha256 "319eae3538250786dd5eb7f20a65bbdd5b63f457f6faa6ef567f3429a0392c34" => :catalina
    sha256 "b527158c00c42fd70d1019927cc6bedbca7585a4de2369dd7d7d44a6f795482d" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"

  # Fix build with recent cairo, remove in next release
  # https://github.com/vslavik/diff-pdf/pull/69
  patch do
    url "https://github.com/vslavik/diff-pdf/commit/00fd9ab8.patch?full_index=1"
    sha256 "62e37adf219f9b822f5a313367b41596873308eb3699fa1578486bfc4f10821c"
  end

  def install
    # Remove when patch is removed
    touch "AUTHORS"
    touch "NEWS"
    touch "README"
    touch "ChangeLog"
    system "autoreconf", "-fiv"

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
