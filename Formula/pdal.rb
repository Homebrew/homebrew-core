class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.7.2.tar.gz"
  sha256 "cedfefbe54ca61cbb33d100d619c53873d84f480ff53deec2cf6dd91580f6a61"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "9d05cf0f554fead70d78c89b153cd70b424d7682ee0842770e6dfdbc1dea300d" => :high_sierra
    sha256 "a3ca061671f7a7883a7c0aa5497676356fd449283e8b18d65830ae4c30b8e995" => :sierra
    sha256 "4d68eb0946cbe5853fbc80229e3b40d1f9eeb0d16fdef5a70724733fb46b5d0e" => :el_capitan
  end

  depends_on "cmake" => :build
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
