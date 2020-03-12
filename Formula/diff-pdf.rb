class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"

  bottle do
    cellar :any
    sha256 "607cf96d3f4badae3caf1f7d0175630b22efcdde6b2ccd60cb918c430de9d2db" => :catalina
    sha256 "5849ecb01adc1810856721c652ad300f089d83697e225facf7f6dcea41da8004" => :mojave
    sha256 "9dd3244618fa964a3bf8940bb4031c19a40d0a9dadb9ba206918990519c3c4a7" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/diff-pdf", "-h"
  end
end
