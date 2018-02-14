class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.6.tar.gz"
  sha256 "66baf8510225b34ee24021731758251cd70657dd578c210ae86c78d158f283eb"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "5d709651475f4c2588623540bf3c760e9e6ca023fc055bd82cb08b99cb978390" => :high_sierra
    sha256 "33f66b42d167f8b682fe0a5ca175206cdf004195487225e861d61573eeb84d64" => :sierra
    sha256 "e8b51690f071595820a99997e0b123ed70a3802e8d29538621834290b4002447" => :el_capitan
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
