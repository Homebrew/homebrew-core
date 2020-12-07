class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  license "GPL-2.0-only"
  revision 9

  bottle do
    cellar :any
    sha256 "0d52b634cb4ba1a62b6c7ffe83d0dc63aa958a99d20ca7a0afce42c73e3e88b6" => :big_sur
    sha256 "57e7d12835be14d4ab3679534ab8c8324b38bb67d414b692af12b62ac6d3dddb" => :catalina
    sha256 "f897cc47811a7161a1728ad9d7785cac114fcdbe4c945562366974bde7af83a7" => :mojave
    sha256 "de582d5725c233f418a142f2afd72dbcbca36921c6a7310c3995dd0699e7c420" => :high_sierra
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
