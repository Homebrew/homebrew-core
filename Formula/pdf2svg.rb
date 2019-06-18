class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "http://www.cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/db9052/pdf2svg/archive/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"
  revision 5

  bottle do
    cellar :any
    sha256 "3999f52a6638bd2090feabd62cf91112a6b98bf6577a112771941ec6781eabd8" => :mojave
    sha256 "9477928316e8a5cb7edc7d03568a22a2f2fb87e1440a96e100c79695c1b5cde9" => :high_sierra
    sha256 "ec7f985d7a62787268265f4e05c87d59926a7f242c22972e32418e7cfaa5448e" => :sierra
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
