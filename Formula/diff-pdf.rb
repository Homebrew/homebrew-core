class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_monterey: "12a2460d22a25a1de65ba16546c339335a9ef3c3e8f8136168317ab300be9f52"
    sha256 cellar: :any, arm64_big_sur:  "9fabdb16a81d678b97469aa757efb934f2e82eb10396aa6b08b47b69a91a8271"
    sha256 cellar: :any, monterey:       "ccded18c4023004272b96f455225a18b1b70a0c687d4c5d4e9b6cadfb891aaf8"
    sha256 cellar: :any, big_sur:        "f4150cbac5dc16b8b578cc83ceb5df99fbb3ec02abe9577ee4125c014757cb27"
    sha256 cellar: :any, catalina:       "a835087ab9403ce734633acf93df500f3452e24fae0c9371b6bb28bff9627476"
    sha256 cellar: :any, mojave:         "34bc0d51de3ab5360e02d5f8c360e44f05c5004c3d4de30bd6e93c4b01653a19"
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
