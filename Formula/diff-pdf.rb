class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  license "GPL-2.0"
  revision 4

  bottle do
    cellar :any
    sha256 "c5290ea7a93ba021192f72a2a5d7356ab64f42b6ebc2a2a63ab8f207f4ee5fc1" => :catalina
    sha256 "816f36adb97e076dff351390bee4cd977c5c82e6736ff62eb9200dc1df90f1bb" => :mojave
    sha256 "13d49f79d769f2b905f54002804e18ebd63c7e4800a1dc7050bfaab4887dbc46" => :high_sierra
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
