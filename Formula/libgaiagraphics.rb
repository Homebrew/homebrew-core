class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 4

  bottle do
    cellar :any
    sha256 "96fa1b8c18f022531ebb36212bb27346aef3f563a66d1ee66b77608fe2019f84" => :mojave
    sha256 "0214b2e415ead8026fc796a6f743304188b4453877de09114d3d02ed14bdb13c" => :high_sierra
    sha256 "e84cb82edf2b0a3926f2f6de212107256932643d89f188ddb67f71c08c4218b1" => :sierra
    sha256 "b3419626a7acd62b6afc604769013b661d3bc57736cdf79a262c287432194693" => :el_capitan
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
