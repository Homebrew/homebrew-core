class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  license "GPL-2.0-only"
  revision 7

  bottle do
    cellar :any
    sha256 "ac3faab4eb23dc8eee19dcc2f856b563d4660f8fb296552321e262aba722639b" => :catalina
    sha256 "030a18ebe99c40e8839a4f402570db6c2ba4c0860cd3ea396113e95a5a476ab0" => :mojave
    sha256 "6fb90fcdc8b34d2b73e6e4d94c4f96bd2c5dbf69644b01fe9101b4b3719de4f4" => :high_sierra
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
