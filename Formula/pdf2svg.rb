class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "http://www.cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/db9052/pdf2svg/archive/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"
  revision 4

  bottle do
    cellar :any
    sha256 "72e8c415a7a7f1f9661f43a6f6f624edfaed8d94c2e954847f212ca39a021778" => :mojave
    sha256 "6744c9c679779473e33f590240ff3d5ac73abfd2f4ac9050efd9c7e95f171998" => :high_sierra
    sha256 "ba6b9232b27927695184348ccb8eef5efd1c7a8cbde0d2448dd6f4dc62466e8a" => :sierra
    sha256 "ca28e65059216738a1632e17c0859145fe64f685ae49a6bfebf327b28c18e69d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pdf2svg", test_fixtures("test.pdf"), "test.svg"
  end
end
