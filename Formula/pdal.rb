class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.7.1.tar.gz"
  sha256 "a560d3962b5ffdf58876155b33f816f24dbaf9a313ae308d9bf63adb8edac951"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "e95c36d5b8807f23d0ca6da602612e3b549fe67e0c2698730e8f9f07ba0d3b0e" => :high_sierra
    sha256 "d3c7fc982b88d7491cd8808d064782540e015c27a7324dcb4daa80730a6901e9" => :sierra
    sha256 "6e8f18ded64cc21360df8fec37971ef48b78fd47e7601b73edff2782611d0b45" => :el_capitan
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
