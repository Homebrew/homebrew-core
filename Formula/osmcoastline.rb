class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "383b7271348c37202ec542d3022e197c69da8608420300bd6a42450f67b76612"
    sha256 cellar: :any,                 arm64_big_sur:  "6b0f73d2184f267b9f5a7e50145739da0990e065b825ee226f059b5592452c99"
    sha256 cellar: :any,                 monterey:       "18db1e798ba515417c85b01e0b95d00a9ba1e296ee263a4082a821537e341bd3"
    sha256 cellar: :any,                 big_sur:        "ec8e27c3feb251618d6aa028669b01c44114674b5829ec8a2d63445719438b21"
    sha256 cellar: :any,                 catalina:       "f40b1f1fa46d354e8555e7f89b3a479acf3de70b5ea2425bf610b8ed577c2580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e795926739cc6a42fda90adf4bee1fc50a9b65c804078002fd5083e3e255fee7"
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
