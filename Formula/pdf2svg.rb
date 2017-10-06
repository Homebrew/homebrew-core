class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "http://www.cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/db9052/pdf2svg/archive/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"
  revision 3

  bottle do
    cellar :any
    sha256 "c57b1efab2f8c4b9e501ed58a9e0611b972597c2d0c394f3418e28c565222b02" => :high_sierra
    sha256 "a574a847ce8935f2a211415663615622bc085ca0ea4773b5cfc84b16e65675d3" => :sierra
    sha256 "d34fb16f1ce0e44158403ad5dfcb8fc4122ae484957aee341b6f430a4c44eac3" => :el_capitan
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
