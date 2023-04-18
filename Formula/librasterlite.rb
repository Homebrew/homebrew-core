class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 8

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d5fb61007c0084ec3656247e1dfc8317508a26f833ae11f190c82ba13bac5fab"
    sha256 cellar: :any,                 arm64_monterey: "631ed6e41434a21f397ba2e46abc9a21b38a02ffb242826de1ec41279e542c47"
    sha256 cellar: :any,                 arm64_big_sur:  "965a159592b0bdd5356394ec249e5d9b39fbc8f639d588fa8785e3017d4ed7d1"
    sha256 cellar: :any,                 ventura:        "e31b0402ab1815687b14f730ac6ce7bd4dcb48c97645d39227beb6e11f7cf3e5"
    sha256 cellar: :any,                 monterey:       "064b6c1643772873e6677a7bb3b55c0fd619bc24f99a0d61e0dd339bec3e9703"
    sha256 cellar: :any,                 big_sur:        "8490d5b9dc2d9f6f1e4e5c0e8793618f7a40b5c1227ec2157bfbaaf49ce0e5d9"
    sha256 cellar: :any,                 catalina:       "77b16b08a0879b323bfdc17c437809fef2a4350820ab1c754acb8d9b91cf6921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43fd1aa1f5992cc5bc82499d6a8c0783e8560caaf1d5f83fd74b226846e5c1e5"
  end

  deprecate! date: "2022-03-05", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "libspatialite"
  depends_on "proj@7"
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
