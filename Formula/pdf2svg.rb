class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "http://www.cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/db9052/pdf2svg/archive/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"
  revision 3

  bottle do
    cellar :any
    sha256 "1ab2d2aa1abc0ecec13d0465cab9844854e95b5cfaa0014c8c16e2961beb526a" => :high_sierra
    sha256 "f2d8ad8defe79c2ca36145297aa8e24558ab248e5e45defe9d5c249184b699c0" => :sierra
    sha256 "35b6af439ce9c6be306df8c7fbe4855a50673db6ba1261c6a87f78583cc17205" => :el_capitan
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
