class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 4

  bottle do
    cellar :any
    sha256 "0a776d9f46cc0a829b65cc97ebefc04508886779e4fb6863934e5064de1545cf" => :mojave
    sha256 "65caf1ad410dbec8ab61630fd43051eebdc0a152278ceacb1b9f9c470f7daaf2" => :high_sierra
    sha256 "c35a4604e8ca5b6bff8368bdf18f42858b7c1e616c2153539d91f92f3d1cba22" => :sierra
    sha256 "24120f69886a7fcd617896f8b80c4d25648a840eb44b14d3a0ee1457230810e1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "libspatialite"
  depends_on "sqlite"

  def install
    # Ensure Homebrew SQLite libraries are found before the system SQLite
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
