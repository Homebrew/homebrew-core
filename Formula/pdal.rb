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
    sha256                               arm64_monterey: "998dda3bab8682185092cf3c3cd019f2b5d3678367dba539a781108db1bb11ec"
    sha256                               arm64_big_sur:  "5b011e401cd6355232abec02411dbb4eec0120be84165d9f1e5c3afe01150d2e"
    sha256                               monterey:       "5bd56fe6425d85b67e127d67ba9144c21cb4f78c0792836726182bb3e44f3860"
    sha256                               big_sur:        "24b0f9bc866c49dae38f5b5ea9352b537d83fe55e81226d9ff90401534f5df4b"
    sha256                               catalina:       "e613c1bda5f8f4004438faa55d8e1be91d4727f467067f6a25f3f4671781c419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aad3d4e280d139b4f45701947fb6565a07101a58837f6f1cf56a632af57fe5fa"
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
