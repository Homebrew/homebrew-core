class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.0/PDAL-2.4.0-src.tar.gz"
  sha256 "c08e56c0d3931ab9e612172d5836673dfa2d5e6b2bf4f8d22c912b126b590b15"
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
    sha256                               arm64_monterey: "8405c1fbd8daa37e08f631c5d6872f6acecc4ae8cae41f46dc66b451e01d189c"
    sha256                               arm64_big_sur:  "c7bed4f32900664bfa9c4bb37decbaeb2cd56fd398d78a1c9dd2f9f9ceeb55d0"
    sha256                               monterey:       "e4be0bfa5723b80f2a6a40516405920a288655974cbf254d6120c4b2aa466bac"
    sha256                               big_sur:        "3087d58b14d2a842e712b7f630535b256b8499b726a7183af4de5cc0a0f68f1f"
    sha256                               catalina:       "2a8f446d8be02ec9216900410107ef519f7aa31986d52ad46f15cedf66e1e2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe23cbb8b0514dbe5611ef6ec86797475c16a2352ec9ef3413487856baa44d60"
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
