class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/1.9.0/PDAL-1.9.0-src.tar.gz"
  sha256 "bc010da5259bf2adecce9543696e8c17e7c177da70e3774f60b329d8e02d9cd8"
  revision 2
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "91ab91b73628331c465baa9c958c61efb74e5a83a2c9dd1f4f8b9fba6cc6ce9a" => :mojave
    sha256 "0a4304f2cf27e9614851e4783693eae9d702ab92ac5756da7b2c742bde553784" => :high_sierra
    sha256 "d69dc051a17749ef32698b5a194249a4d6083ede70fd6e8184d210bcb7dafd9f" => :sierra
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
