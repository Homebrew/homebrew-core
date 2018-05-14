class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.7.2.tar.gz"
  sha256 "cedfefbe54ca61cbb33d100d619c53873d84f480ff53deec2cf6dd91580f6a61"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "9fc7e920fb34e5b966b4592c9d649ea6042179e85c6058a2c2f2ea9632f63b10" => :sierra_or_later
    sha256 "804a50262bcbda1317bb3c07b9b1c9dc53da3721c719c94d53278f3190b497f0" => :el_capitan
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
