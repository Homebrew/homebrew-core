class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  license "LGPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12b2678c043fdd30f90f3773db50181cd3b0f76b2691c7d316e7c20e1c91d603"
    sha256 cellar: :any,                 arm64_monterey: "42eff6244781ddd1d413987ca9f129c9f741e108d98a42dc23e3fe05cfe895a8"
    sha256 cellar: :any,                 arm64_big_sur:  "f83975606bf2054bef66c6f8c131d395e2b6dd1dc8f6b7e19063393cf176bf95"
    sha256 cellar: :any,                 ventura:        "15465f55135762b64ec777636ccb72a9c00e945c3ca254c41288a6fb84155e34"
    sha256 cellar: :any,                 monterey:       "b24aeea6a6fe6843982d28ac44ecc6219ff7432d6f88e74c0e28eac09b353055"
    sha256 cellar: :any,                 big_sur:        "ee41f28f60ac786ed7fadd63a40cdd44c4b798b9376e3202967f3109dfe76626"
    sha256 cellar: :any,                 catalina:       "52f249e8450b7d9c54db47c1002e0c72858b075e0ab393e8aa5f53ec90a2338e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b71c3137ca5d17cf2e9196d8d5d08dd3ff0b991efcde56426e81eef48cb954a"
  end

  deprecate! date: "2022-03-05", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "jpeg-turbo"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "proj@7"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
