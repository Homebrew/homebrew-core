class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 23

  bottle do
    cellar :any
    sha256 "1873871b25187774ae1e6eaa5cd2ea6d579d0b516a1d88d544aef88f1ca638ba" => :high_sierra
    sha256 "9f037de7519f4a22db64c589fff08bd06b2f9f25e89335cd727c39fbf1afd2aa" => :sierra
    sha256 "cd701284559db5c34c1bf25204688cd5f33fba031a49410026aea2e82dd8bdf0" => :el_capitan
    sha256 "775ca610774bf01a62223abd5dd587930508ec079718845ef6b3b5ce4d7b9b90" => :yosemite
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
