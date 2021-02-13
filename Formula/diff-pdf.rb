class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "86e670f863f6b811b886a7ae58754a44325ec03b72967e594e07c26f9b2f4e5c"
    sha256 cellar: :any, big_sur:       "14f985b5563212be377d5f71dc657b098fa17d9aaaf35bf4ba18d8265c937d9b"
    sha256 cellar: :any, catalina:      "c84026bc89b534fc6be2becf80af431c018bd6705a99d67b660b29a677be9bb7"
    sha256 cellar: :any, mojave:        "69eec0668722b2bac9a01115ef4304275ecccd1f9f32bf9d4393910f42e7aad7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"

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
