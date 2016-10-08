class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 14

  bottle do
    cellar :any
    sha256 "2c0239d2d1dbbc9fe36f8b8cc1b42a1851f0406fcfde0966ad58d5694e88477f" => :sierra
    sha256 "e9fc598ac0bfcdb0d75af8e29307c41e54f7a2493b717669c1ebfabbd16eb2f7" => :el_capitan
    sha256 "68a5704bb4061d033b06b84643a5221a58d237665de409163be5ab63cf1bb671" => :yosemite
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
