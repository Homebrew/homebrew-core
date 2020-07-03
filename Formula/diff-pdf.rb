class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  revision 4

  bottle do
    cellar :any
    sha256 "9a8f2656e6cbea41f2fb3b4a660997bbaf088b74685fbc96fb6c82f68b3bc34b" => :catalina
    sha256 "52e2dd7983cc2ab92b99987da438757eaadd098aff3b493ca88db98996f2f7e9" => :mojave
    sha256 "364c1ecd345d11ec57e8a91bd4f3368bd5aa1d15244abc582461e09275c8f072" => :high_sierra
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
