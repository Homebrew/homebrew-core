class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3c3de6f11098241c9c5308da232e63cb4719d93023edd7d7cb5b6f3729e70a3b"
    sha256 cellar: :any,                 arm64_big_sur:  "961220957e7f1f1e5e390c76de13afa67aebdacf3f6939b8eb410356e3237663"
    sha256 cellar: :any,                 monterey:       "8154c5d50db171a216b7e8329a674f2059a8eb0923fe3e085f33b575d32c8df9"
    sha256 cellar: :any,                 big_sur:        "0061dda8ad6ed87cf2e73953ed2d658ec00c953157aae00a30ee27b5a14dc065"
    sha256 cellar: :any,                 catalina:       "6e29bd319d5dbf9d3fa7fa1f4af8bdc16bdedb2617ba5129737000374718cccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5fe46fd3c5ceaf2c6af41cf7bb36d265c443ca564dca914ce6a724c38282b84"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"input.opl").write <<~EOS
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    EOS
    system "#{bin}/osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
