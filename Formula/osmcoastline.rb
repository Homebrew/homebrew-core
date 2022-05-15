class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a4a1308b8b9800389d18c4bee83847da6b96175148f3e24d4a147349216da5da"
    sha256 cellar: :any,                 arm64_big_sur:  "d4ea887639727da1386fe1cf96aa457b5763a0d7efdeea8f92687e737a6dccc5"
    sha256 cellar: :any,                 monterey:       "39616d8539d2852880da3337a58608bb18d36d4146106790ec19c7a666ece4f3"
    sha256 cellar: :any,                 big_sur:        "2ff36b87287f9d07f05f930b09311c7885bed51d9389173e72273b51f7a636d5"
    sha256 cellar: :any,                 catalina:       "b64b4333a29538181379adcf123a948d4aa8643a14a4afbeda3475c1a95c175c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c920545c2abb9745b211f14188a6b75a1245780b5b75d8754b032a170accb0"
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
