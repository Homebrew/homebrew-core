class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f0c753f2e7cd3a17ae026ecf3142a32569a59688443060ece97724351b5ff37"
    sha256 cellar: :any,                 arm64_monterey: "919661bc941352bb6f746bc3367ef76e040606476343b3e42dc64f26731af86c"
    sha256 cellar: :any,                 arm64_big_sur:  "047dfe40dfdafad2bad1efc9ba381fb84d32ece1bffe06d6aa80b43afa59bdbf"
    sha256 cellar: :any,                 ventura:        "105fd62c6c4fb5d00c86126c832157ca3b7b003399fb97fa7de78640d3da8460"
    sha256 cellar: :any,                 monterey:       "dfa1ccb730b7f016ea605649215ec81e60f3be9c45ae9b7f89d95e67a7620e3a"
    sha256 cellar: :any,                 big_sur:        "de5039e0d2887b441a1a8dc4f624369af8e1d4123fe60c961a7fec14bff631ef"
    sha256 cellar: :any,                 catalina:       "5e0de9d461e7c3ea17ebb01e1fe7b058c5a828b2eca77bb2a8ab4fdb304f8da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e0534e32f3ebf397989838e836178ec1cb067b1447c37326ca1c04fd8e06c2c"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
