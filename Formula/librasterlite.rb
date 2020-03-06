class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 7

  bottle do
    cellar :any
    sha256 "a66bb073375cf60241540cedba00415ac85fde9b64106f76a5a052a1da508661" => :catalina
    sha256 "e50438fe42116fd2206c46ad813bd65ea732513f2993293d5c8211b38c7642e0" => :mojave
    sha256 "b622c859952b981aea4443d46fc24948a653ed4faaf83184347af82699f2f74e" => :high_sierra
    sha256 "7605cd6756f69c93737ae300e946b81e559d8c5c697bcdfae1f9c1b80b84f657" => :sierra
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
