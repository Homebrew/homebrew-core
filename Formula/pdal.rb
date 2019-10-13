class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.0.1/PDAL-2.0.1-src.tar.gz"
  sha256 "7632808f49ff7defa042e810ab8696beb3e59458082126edd14f7be7ae463cbe"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "9d9702bb0deea6371453e41f6baaa3d5f93c3af1db1336877ba53961d3eea27c" => :mojave
    sha256 "f0e3f632c3b660f89f000e5fa269403c236224f875a103e59c08c834c4a0e7d6" => :high_sierra
    sha256 "1e056660fb1fe4a157029923d657eb83fcede3ba5e56ea929ea1831fbd0db86c" => :sierra
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
