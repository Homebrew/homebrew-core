class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  license "GPL-2.0-only"
  revision 6

  bottle do
    cellar :any
    sha256 "e091cf922dbf2d6e14e7436a1df10fd2bce8f5aee73623481ad6dca1c12ff566" => :catalina
    sha256 "6a911ce7e2c5cfca41bac0d98cb0afa8686f30bfc6dfd8a3238c1753e4233a46" => :mojave
    sha256 "c902128741567e2cbf390ba5d35fb8821c7020717876a575233a790ef3c257a3" => :high_sierra
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
