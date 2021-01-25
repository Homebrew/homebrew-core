class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 7

  bottle do
    cellar :any
    sha256 "d6fc5943cd16fd63e2e0c599c2790fb97ec6af38ccc61305e6cfafdaa195a81d" => :big_sur
    sha256 "19919f543a85e1890dfaee593945ce9427d71ac10c7f02b5895a2654981f1d91" => :arm64_big_sur
    sha256 "566f8ba211d425ca07a06d98f4d6e2ef961eba32293fc83730eb654c3f9a0d2f" => :catalina
    sha256 "28508bacd17ad8c11369d11a99bdc7118c41b50de1a0bbb8b3a0c50117b02c2d" => :mojave
    sha256 "23792ab784c100ea583bbcd570ba2f093aa591438fa2f660b365bb7d99f0b999" => :high_sierra
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
