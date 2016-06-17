class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 11

  bottle do
    cellar :any
    sha256 "25a90464e68579c0bab6a11b34bcd8db9ac4dc695035ac4ec6d35638ed6507a6" => :el_capitan
    sha256 "ec3dac35dab0bdc3d7a08eee6f75196af15ecccc35bd75d3f65a45a85e181f66" => :yosemite
    sha256 "4bb2923dbcfa3331108720f031c1a19207e8b6654f100d5874205f0e7f2e64d3" => :mavericks
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
