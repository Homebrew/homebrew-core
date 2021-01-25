class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.2.0/PDAL-2.2.0-src.tar.gz"
  sha256 "421e94beafbfda6db642e61199bc4605eade5cab5d2e54585e08f4b27438e568"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "ab6cfe4dd4892db1c461ed336a361afafe1ab396ad48d6b62738517e44a8a3af" => :big_sur
    sha256 "282f7fa863a01ec05807e3e262ff90357e2c7003ee472a752ef1d21ba7f33aa7" => :arm64_big_sur
    sha256 "4d2cdd582fff619e8224292422b70de75381b95bdd7dd03af535769bbda0d061" => :catalina
    sha256 "7f7191678e93323c1763c8eefb710f365d0a289633385acc5e69e146db29687f" => :mojave
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
