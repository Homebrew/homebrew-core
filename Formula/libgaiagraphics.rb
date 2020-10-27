class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 7

  bottle do
    cellar :any
    sha256 "05b3806c31a6e084eeeec2e44c83b8fb728cd0de4cc22dae14888ff52e290cca" => :catalina
    sha256 "bfaf50e26b9312c1ef7d9b62677e92099339d14393ce855b870fe9288503c5df" => :mojave
    sha256 "20a230ae5fccd2d5114e8ab7a128dd57834104461e5a7cbc2f7c7e63075214d9" => :high_sierra
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
