class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 26

  bottle do
    cellar :any
    sha256 "e8978e8db26c12a8e93b76f2bc7014f8ba97c5f8283423fd2878a7c951dda2f5" => :high_sierra
    sha256 "08957118a9e6ccf2f9a6e0a9b1576bf137ce9877b41bec2a3f4ebd05ac915c9a" => :sierra
    sha256 "fb439244a964fe45b7d6b03aad3bd958682e734a5df4edb3a452b82847f8b55a" => :el_capitan
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
