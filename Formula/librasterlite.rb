class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 2

  bottle do
    cellar :any
    sha256 "6a1ad2cd9fc6c266be738c52824b0ed08ca907e8ff402bbb5e54527506321f21" => :sierra
    sha256 "48063ae34020277b6eae28b25bdef98effa7e6f76a5f652f117a7c1639c17558" => :el_capitan
    sha256 "4f849a0bb992fd9c60f882b2eed4bd1a5b6a29a8669dd81287827c395c4c8d53" => :yosemite
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
