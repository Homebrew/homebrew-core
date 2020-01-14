class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.0.1/PDAL-2.0.1-src.tar.gz"
  sha256 "7632808f49ff7defa042e810ab8696beb3e59458082126edd14f7be7ae463cbe"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    rebuild 1
    sha256 "cd83816acd8f7f4328f7e327eb33fda0d40dece97255a40415fc1f3c19539e52" => :catalina
    sha256 "deb26dd7d9f1fff59e075aa2e290bc6b8ce5a9852838a232f2954e77ef220907" => :mojave
    sha256 "f2865ee1f77d01b1f5b62b24ef4f3a4aeb4db2cdab9cbd0b315c3d9666fd8b31" => :high_sierra
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
