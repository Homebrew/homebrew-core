class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 6

  bottle do
    cellar :any
    sha256 "58229defc96e51dae005394c39ef966b863d11b72104b292e152bbecfedb62ef" => :mojave
    sha256 "af03ff686e021b4a06829f50fedb1bee35aab1c05971b22b92c0799e429cf4e7" => :high_sierra
    sha256 "0b77576cd8c718d2f558f401e3a34ceeef5d8b87e5d872f1a09d88de427f4b6d" => :sierra
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
