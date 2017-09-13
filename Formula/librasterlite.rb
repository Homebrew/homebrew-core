class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 3

  bottle do
    cellar :any
    sha256 "e0c6a73f26ccdc9c730ffb04a791528b0338252afcf5c9f5ba9ca583b45ca7a7" => :sierra
    sha256 "778da1f5f7c2b91d82afef12f4061dda7853c27cdc9130307b71011e3fa48229" => :el_capitan
    sha256 "f19789002b0677c718b39361d3311b7a321c6d33290ce59dbc31d2061e1df58b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libgeotiff"
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
