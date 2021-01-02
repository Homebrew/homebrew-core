class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "https://cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/db9052/pdf2svg/archive/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"
  license "GPL-2.0"
  revision 6

  bottle do
    cellar :any
    sha256 "8c3412a41015f7155602d6e91eceec825fc4ca7ec1866245c1388dcd950fad24" => :big_sur
    sha256 "637306ef53eb8ba77c905cba19e31c2f411a2589528a690c566a56f6a7a195bd" => :arm64_big_sur
    sha256 "8350da4f06838454cf26788b9ea27cbd9255d567be906d4fde5dea332b035734" => :catalina
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
