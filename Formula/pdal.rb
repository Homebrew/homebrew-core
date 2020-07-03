class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.1.0/PDAL-2.1.0-src.tar.gz"
  sha256 "c300de7935d52cb96e24bdaceea5d189b1840e88636e6deca1f6dad51f909571"
  revision 2
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "332feb8e61a019dc8dd130be5b2b0aacf0200bcdc861b547dd270cd96fecd813" => :catalina
    sha256 "c1b129ee18b0fb9cf67de9a149a9d636d64d7f04d24d25ba5567f755b85cdb03" => :mojave
    sha256 "cdb1c42f388ed209b9b569c381f3657c88fcf1112aa0ff8d1d98cf8914093eee" => :high_sierra
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
