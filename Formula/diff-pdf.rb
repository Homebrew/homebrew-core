class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  license "GPL-2.0-only"
  revision 10

  bottle do
    cellar :any
    sha256 "14f985b5563212be377d5f71dc657b098fa17d9aaaf35bf4ba18d8265c937d9b" => :big_sur
    sha256 "86e670f863f6b811b886a7ae58754a44325ec03b72967e594e07c26f9b2f4e5c" => :arm64_big_sur
    sha256 "c84026bc89b534fc6be2becf80af431c018bd6705a99d67b660b29a677be9bb7" => :catalina
    sha256 "69eec0668722b2bac9a01115ef4304275ecccd1f9f32bf9d4393910f42e7aad7" => :mojave
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
