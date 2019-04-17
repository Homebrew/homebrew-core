class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.8.0.tar.gz"
  sha256 "ef3a32c06865383feac46fd7eb7491f034cad6b0b246b3c917271ae0c8f25b69"
  revision 4
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "2e7d260b134126dd8ca5288278c238340d52db05bc7ca07fa2f8908c6364e265" => :mojave
    sha256 "1574e5457f56773902eff4f7af6e7953cbd43a32f0b13f547d79bf616797ea1b" => :high_sierra
    sha256 "eee1837ffb9861a85633f51c822679af7707459b3c1789bf92e3c98be6cac99f" => :sierra
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
