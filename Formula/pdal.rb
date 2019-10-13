class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.0.1/PDAL-2.0.1-src.tar.gz"
  sha256 "7632808f49ff7defa042e810ab8696beb3e59458082126edd14f7be7ae463cbe"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "b6b38e62c87b28985bba32abbd61c5fcc8d0fa2bd5cd2aabbbbca0debabd3256" => :catalina
    sha256 "76d2630b0fd6351c6ddd900c9946d48d2162ee10d516aae7f99367e8c2620daf" => :mojave
    sha256 "00ea9635ce86ebb1783ecf798ebc85e35928594e596408471a8181ef894d86fe" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "numpy"
  depends_on "pcl"
  depends_on "postgresql"

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
                         "-DBUILD_PLUGIN_PCL=ON",
                         "-DBUILD_PLUGIN_PGPOINTCLOUD=ON",
                         "-DBUILD_PLUGIN_PYTHON=ON",
                         "-DBUILD_PLUGIN_SQLITE=ON"

    system "make", "install"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end
