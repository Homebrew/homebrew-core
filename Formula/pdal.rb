class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.1.0/PDAL-2.1.0-src.tar.gz"
  sha256 "c300de7935d52cb96e24bdaceea5d189b1840e88636e6deca1f6dad51f909571"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "80efce0dcdc05c162474156febe44961f7efd9e58fe234566df2597141e4678b" => :catalina
    sha256 "ca60deeda7305438f673881f12425ca6cc51f9d8f06bf493581105165181f290" => :mojave
    sha256 "f2ea432dde7b45ddd71fa79c52960554a2812d1840c9354f5602795bc5d241ca" => :high_sierra
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
