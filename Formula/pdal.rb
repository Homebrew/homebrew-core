class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/1.9.0/PDAL-1.9.0-src.tar.gz"
  sha256 "bc010da5259bf2adecce9543696e8c17e7c177da70e3774f60b329d8e02d9cd8"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "e7fd98b0e12731feb8cd0744dbdc83d725a6ad714e891edf6725b58f23599b32" => :mojave
    sha256 "5d5ec917b6002ebf7310442aff502b4e1234bb7e3b772dabdfa62e762f70fb94" => :high_sierra
    sha256 "8c2b5efc43a39eb4a09ba7345e5d5d9cfd3273cb093107483434616aed8edb82" => :sierra
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
