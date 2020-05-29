class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  revision 3

  bottle do
    cellar :any
    sha256 "a3e92cfda284e36dcf074032dbea1532fcbc929e97ac2297e5158e0580af6367" => :catalina
    sha256 "460b61cddc4bfd049c28337b5b30179d3029129a0e484001e7467acd40f0b51e" => :mojave
    sha256 "94d9290d9735942681d560be7439c08cddfebac246d3576a579021f01f3e5d95" => :high_sierra
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
