class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 3

  bottle do
    cellar :any
    sha256 "ccaa04675ff26b09b702e04f3141a7d151324afc1cdbe93722d47dfcdfc90672" => :sierra
    sha256 "97c8c5d1b5dc8b054345b166eec48986cbf8bd11c0b7fd0554269a5e8cac4cfa" => :el_capitan
    sha256 "76166f59036fa616a8273bc0e82b928356f4991c81f9aec6cb064dd135e6da91" => :yosemite
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
