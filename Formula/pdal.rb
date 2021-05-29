class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.2.0/PDAL-2.2.0-src.tar.gz"
  sha256 "421e94beafbfda6db642e61199bc4605eade5cab5d2e54585e08f4b27438e568"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/PDAL/PDAL.git"

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
    sha256 arm64_big_sur: "9eeb18f3dbf4cde5dcc641be1e06237ddc88d615be7fe95bf9b1f8ac50fa1922"
    sha256 big_sur:       "fcf5c16aaa8e0b03174f97ca817f5da2409b671802532aa619ddc21cda1f1bd8"
    sha256 catalina:      "fcdf73a941cce2a7256475102f7fc7482a86e41509877b56dad05caa2b960aba"
    sha256 mojave:        "452cff9b33890e6ec9b73e8ed32048eed8adac77d42bad09460973bdb826399d"
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
