class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.1.0/PDAL-2.1.0-src.tar.gz"
  sha256 "c300de7935d52cb96e24bdaceea5d189b1840e88636e6deca1f6dad51f909571"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "6c90c29b08b0c6794a1616315954ff67900c6457bee800bb3a5bfd718804f263" => :catalina
    sha256 "40b4c9a1b05d80964c910c2b483ec34cbff031295e9f9b603d9f984fd3fde5c6" => :mojave
    sha256 "578aca3ffed538962b3be05263188be7c18c63ac41a4267fdaaade2118371f4b" => :high_sierra
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
