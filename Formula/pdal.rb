class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.7.1.tar.gz"
  sha256 "a560d3962b5ffdf58876155b33f816f24dbaf9a313ae308d9bf63adb8edac951"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "0aeb667c6999ea5e0b5311c937e8ed6fb531f5050bfdf3d1f896b8900c24f7a3" => :sierra_or_later
    sha256 "51da869747d6a62137ca22fa672c154ffc33338e7ba794238fce8d8f9d363b83" => :el_capitan
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
