class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.2.0/PDAL-2.2.0-src.tar.gz"
  sha256 "421e94beafbfda6db642e61199bc4605eade5cab5d2e54585e08f4b27438e568"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "891506bdb2c472daa21ba458d6d52d71f1aa70b1f7dbae2c70f3b21977b016e9" => :big_sur
    sha256 "704621f65b657ada078747030eb336ddcd92f67b3382f6662f4f5ee66079348f" => :arm64_big_sur
    sha256 "ff1bcf0dc89090c9a0f542403b383356af63fe83872a072ed9538ed61797353d" => :catalina
    sha256 "68f240bac142ac17134d7fe0cfd5522dc0d73391fe5236987d1f9ae0b7a5f4b0" => :mojave
    sha256 "fcfaaa69177ce2f263013dec667a309c78140104f9d4520f212bcfd0986ddeea" => :high_sierra
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
