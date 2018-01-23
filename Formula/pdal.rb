class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.6.tar.gz"
  sha256 "66baf8510225b34ee24021731758251cd70657dd578c210ae86c78d158f283eb"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "86de5e976cacc9ab92e05c63a769121daa18e09fe04d983eaee035ba1fac2c56" => :high_sierra
    sha256 "7d43831fa9967d4cdd72cf5f1f2f194377a95bbdab3a5ca077a57e8944231c06" => :sierra
    sha256 "5fb6e7746c1b90c7ac70610a2cec1ee3ebc34499c4a69289ada098d81499adc1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
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
