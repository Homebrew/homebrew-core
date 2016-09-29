class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 13

  bottle do
    cellar :any
    sha256 "26033ef83ec3ad9ceec2dde0b127b51098ec330107132b55f101ee3d32d2e3d7" => :sierra
    sha256 "6ff120b0fa4ba236444a43e21d1931b24e5516b3502bdb22a0217eb5ce8f6434" => :el_capitan
    sha256 "15ccc27091949b041ba99b2f15f23ed8643233e43afb007ae49e80e2bb5ebd82" => :yosemite
    sha256 "244d2fd4c442106a7b97f2790d2772753e9b972c8f03266ef5f71d2006d0223b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on :x11
  depends_on "wxmac"
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "./bootstrap"
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
