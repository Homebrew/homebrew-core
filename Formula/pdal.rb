class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.3.0/PDAL-2.3.0-src.tar.gz"
  sha256 "5b0b92258874ef722b5027054d64c8b318b524e7a9b2b250d0330d76e19b8618"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes tags a commit with only a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.3`) for
  # the release (with downloadable assets). This inconsistency can be a problem
  # if we need to substitute the version from livecheck in the `stable` URL, so
  # we use the `GithubLatest` strategy here.
  livecheck do
    url :stable
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "bab6bc4359165c0114f42bfaa336efd455f4be53504b4c9ccd730f69fa4138e6"
    sha256 big_sur:       "c5b53c3b047b1cc147c4b7a2b32337c219f29b04ca5badb054ba2c5d282f6d6f"
    sha256 catalina:      "5ed3e147a0d6078d4757b59ec97edd1b582c6e696f0c1a7b458deed020be38c7"
    sha256 mojave:        "c907f76ffd95101e6d7555cc0f7da93c0380e03a54973b03c02e0be0998e8b79"
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
