class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "http://www.cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/db9052/pdf2svg/archive/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"
  revision 1

  bottle do
    cellar :any
    sha256 "72720d163c7b21b7aedcd00ef9730b6173f3928082eb404bc5445f13a7284ca1" => :sierra
    sha256 "37a695cd77dbd082006a9d4581f1da885aeb6b3e557cbc679fe551b150c317df" => :el_capitan
    sha256 "cff3cfd6fa07b5af5074540e4f7329160b1ecd71819310018a36ebf0a0b8b34f" => :yosemite
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
