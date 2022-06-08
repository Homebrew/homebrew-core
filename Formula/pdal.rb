class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.2/PDAL-2.4.2-src.tar.gz"
  sha256 "582309942dc7b0fe9c3e652aa4c9c3ec3b8c6f56401a0bf3f6237d3347e8f616"
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
    sha256                               arm64_monterey: "5bbac712512fe9720c36f7589d04a8183537e372781964fce6d05b370ddc661e"
    sha256                               arm64_big_sur:  "aa03c24450cc9f5cd7c67a08873e7c2ef61872307b8f3b8d501500295795e739"
    sha256                               monterey:       "b76a0c6665c4a3d1a535755f6f6df8c3c9dc7b14d50d128605765a23ba7c3424"
    sha256                               big_sur:        "4005f577331532b9c2d909af46540e0d24dc664d3c7cc33e2663093f106a5b3d"
    sha256                               catalina:       "e2357208c86665de7300dc9d2587edad80d8c332d7baf084a24f3c514ba5fe05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5435c0ec7fa4800c6c9600ca02e7a7946cd2e7f23a3be6e90db05135693cb29a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "numpy"
  depends_on "pcl"
  depends_on "postgresql"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # gdal is compiled with GCC

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
