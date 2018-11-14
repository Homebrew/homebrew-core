class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.8.0.tar.gz"
  sha256 "ef3a32c06865383feac46fd7eb7491f034cad6b0b246b3c917271ae0c8f25b69"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "c211158a9c99b6ab8a9878abf9fe10d6dc99b42f3f6245f7e593c0969c692484" => :mojave
    sha256 "5028bf4fb5ccdbbcaf3b09894749130dc7f78232376c61cb7bb6bcf2887d68d8" => :high_sierra
    sha256 "6d050bb1dcc847ec9daf0b5084b09f3a4f29b946378eae6145c5d95f6eb99213" => :sierra
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
