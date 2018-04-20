class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.7.1.tar.gz"
  sha256 "a560d3962b5ffdf58876155b33f816f24dbaf9a313ae308d9bf63adb8edac951"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "023eabc1b5936f68d22f449523d031ade6c226f5cc001e24fc18e5b7a89a2cbc" => :high_sierra
    sha256 "62ebaf21b4dcf1afec384c417f6903177a9b75a7633e60cd17e7a8108c204157" => :sierra
    sha256 "66771bf1a508a9191296ab451a2d0edf02e3541dad30055fea91f193e6f944b9" => :el_capitan
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
