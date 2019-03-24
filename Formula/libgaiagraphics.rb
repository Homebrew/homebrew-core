class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 5

  bottle do
    cellar :any
    sha256 "f32bbb80c77f637c3e6a2750273aa538b5216f8f74df58c2f4e8a7a789d629c7" => :mojave
    sha256 "aa79227a117c57090885c99f8419ea14acd5af2e1101af06b84d72edaaaf3101" => :high_sierra
    sha256 "05cc87204dd39dfafc44c1e2cca791001b4796382c77227d6c0fc0f45e00da11" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "jpeg"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "proj"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
