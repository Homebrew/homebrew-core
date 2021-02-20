class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3abff1045972a9a20e5c151ffbb7a0bb9793b39374485987ffd00f8c0c8e9ebd"
    sha256 cellar: :any, big_sur:       "09483c6a3648a715a8e1fda4d3c89658b59835af35ee075a767b919c94ff19ef"
    sha256 cellar: :any, catalina:      "3b5b2064c54199351340d4a41a54cadc075daa683065c57eaaf98bdee4af3eca"
    sha256 cellar: :any, mojave:        "807edca0450757b34c5524fd83b307ab55481095f09d7674c5e9f623596702f0"
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
