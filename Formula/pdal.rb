class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.2.0/PDAL-2.2.0-src.tar.gz"
  sha256 "421e94beafbfda6db642e61199bc4605eade5cab5d2e54585e08f4b27438e568"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 arm64_big_sur: "f43d527f411e9f7f5f05d8d222a9905d8884c8c4c755f5c97dde94c25e3dba35"
    sha256 big_sur:       "38ea562310b33f0c87e067cbf807548711bb583ea7afff19139fc94a346cea09"
    sha256 catalina:      "5dfb4410adec9ec76695ab3a6c31928f3f49534905f3aea271a998a9172a9d26"
    sha256 mojave:        "1fd56f223fc51da343f069420643062cc89774f19adcb55ab81bf57da45918f4"
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
