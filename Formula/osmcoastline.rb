class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56597fc77c1b8f3bc5f8044674e7ff7278bcf5f194317558dabd606f81e38364"
    sha256 cellar: :any,                 arm64_monterey: "1466e5d4b67127906cda315646f29753ba429d954ed838293f7c40f218670922"
    sha256 cellar: :any,                 arm64_big_sur:  "207f9ff7c3519275c9a9b6eb9497d4803275b1850cc5a85391f0cb2458d61755"
    sha256 cellar: :any,                 ventura:        "ce5496b8c62637285c27611841589dbcced6c994cb042512a3667635c8a91e5b"
    sha256 cellar: :any,                 monterey:       "0f0fb789a08b5d36f1f00a8fedaab612e7040d28ca3c5da295bf187eced5807a"
    sha256 cellar: :any,                 big_sur:        "094c4f9d90eb4fef7b3ead6042dbd1ec93be58512f100af90e937e40d7e8362a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85922aee124718107810d516095ceebd9644c9ffcf0983951f3ed202ba6c6600"
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
