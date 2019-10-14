class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 6

  bottle do
    cellar :any
    sha256 "7fb0af1a2f51f48e393bc779036350e6e189afe48d8298e6136c42a11e34e072" => :catalina
    sha256 "13fed864f88e14d0e4cefd4b07e4160a032ac61b58452b0d7ccb79418e649a21" => :mojave
    sha256 "957b6289dfd357c8732fba38df3cd0d2b1916709a85c5c0b66382b654d945ee9" => :high_sierra
    sha256 "f3ceb2bfebebc26f1979b0f17eaa0bbbce1735b6680c81276c850dcd2469f4d2" => :sierra
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
