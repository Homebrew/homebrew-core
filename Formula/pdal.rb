class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.3/PDAL-2.4.3-src.tar.gz"
  sha256 "abac604c6dcafdcd8a36a7d00982be966f7da00c37d89db2785637643e963e4c"
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
    sha256                               arm64_monterey: "9c1c9ed099f4d4d3d6e568e3aeeeb6b782961efe8e6f1eaff0d4fd191a701370"
    sha256                               arm64_big_sur:  "9dec68d14c25a0988c046a3a45a46a833c61418f12876ae182fdcaf35d78a643"
    sha256                               monterey:       "ed1a9e84ad79ab1ea15087e3b1786afa81fa5714480e7d33945d7727a92a9af9"
    sha256                               big_sur:        "1ee3f4714addecbb9f515386df4b22460776941b230235513ae17784915abb1d"
    sha256                               catalina:       "6a75d3c7357f7e71ee03bdb077060bf5415d9d976a43b952f10b5ae5fa71bb68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7257a3eb8a20b527f9e357f63f9cd1f203722e86055debf5bc8e6d31d2883942"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"
  depends_on "pcl"

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
