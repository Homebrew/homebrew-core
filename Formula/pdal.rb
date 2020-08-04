class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.1.0/PDAL-2.1.0-src.tar.gz"
  sha256 "c300de7935d52cb96e24bdaceea5d189b1840e88636e6deca1f6dad51f909571"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "da0f5ab64298b3c1eb5d23589a1bc9eda8ae98c3ebd28458f1422d550fec2e71" => :catalina
    sha256 "c770fc0555b3a070cea3fabca63e0ab5c2d8ccd011c3a70aab6af87b4b3f607e" => :mojave
    sha256 "7b9f7e54194ab7f3615a243abde2f3bbb7de666a8babad77a2d42f40a7d44943" => :high_sierra
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
    rm_rf "test/unit"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end
