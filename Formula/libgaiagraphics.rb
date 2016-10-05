class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 2

  bottle do
    cellar :any
    sha256 "9084ed46db17d60af7ad5f384e4e159efc3413d707a829b0942bf27c03fd56ad" => :sierra
    sha256 "dbc0b3d570d96505d3a94bbc4ff4ebc1ac7978911158413a27d6f2b54f0dc338" => :el_capitan
    sha256 "d50e034a248e53e0dcee6aa048ddad6a779e390e521eeb1a5e3f53b62244a275" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libgeotiff"
  depends_on "jpeg"
  depends_on "cairo"
  depends_on "libpng"
  depends_on "proj"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
