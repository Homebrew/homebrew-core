class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.3.0/PDAL-2.3.0-src.tar.gz"
  sha256 "5b0b92258874ef722b5027054d64c8b318b524e7a9b2b250d0330d76e19b8618"
  license "BSD-3-Clause"
  revision 1
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
    sha256 arm64_monterey: "6c2e9fbd5a016f570d86d99cd9c0dcbee73874839f2ac9901727d792e4c0c7ce"
    sha256 arm64_big_sur:  "e3e2a0a482d9127663cb55c9eec4ed08b92a9ecdd1e99369e373eeed6bd42d90"
    sha256 big_sur:        "da4aa1ad9ad2a01463689dc1fe634505763c2aca6f73900d89e3f9c4b22f6640"
    sha256 catalina:       "1ca1144f13120d8e77ee4ea0f460e8a87e00aa2487aefb823edf73df04d4e089"
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
