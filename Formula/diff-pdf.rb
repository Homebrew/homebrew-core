class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 11

  bottle do
    cellar :any
    sha256 "4a52482ec0d5472b33c0ebc42f88ee0c89e9967507b50b791aaf55a49354f62d" => :catalina
    sha256 "7364438a876b3e76ede700fe9f56949e0ad10b84130e579d501e48e448c42fd7" => :mojave
    sha256 "1d9f7280cd36d354cf2f0476b364666ed1d5d93d0f462cbcb2dc08dd876e46b4" => :high_sierra
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
