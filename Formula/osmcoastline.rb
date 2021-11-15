class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e0820b1a6cd6e77dfdd742f29404c5f1b78f9b198a59c7019152e4e9d9608d72"
    sha256 cellar: :any, big_sur:       "f4de31702d99101baff041d2b96bc4bd58f1bd728c07353f5c9f753551ba3d31"
    sha256 cellar: :any, catalina:      "eb5bba76581312e9b070eb5f83b8d98e9862d0f33b13808f5a6f0a33ce3c0973"
    sha256 cellar: :any, mojave:        "37f1b4c9d9fb60ed418eb69292c7f3b9de2cc3b7599f2ba8fed69a1b1ee88d13"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
