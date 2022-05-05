class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.0/PDAL-2.4.0-src.tar.gz"
  sha256 "c08e56c0d3931ab9e612172d5836673dfa2d5e6b2bf4f8d22c912b126b590b15"
  license "BSD-3-Clause"
  revision 3
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
    sha256                               arm64_monterey: "719ada8b1934d00de33d84d2df1f954967c9013d0334d145c00f0270aa10ccea"
    sha256                               arm64_big_sur:  "7d9be502802d9716b9a8c22ddf5d2c1f8be5f2ac30a3bbb81b5cc8535111fe53"
    sha256                               monterey:       "2242cfdda166c3be985c7fcfcfe7ab920fac93ffd8a9922ed6f46ff5b26d11e5"
    sha256                               big_sur:        "175f3cce9e662f4dc7135871ffab53f8bd637550b67ff94e74d7d42aff0688c8"
    sha256                               catalina:       "c55b6880492ba0fc4ff8c6e69d8bf3b3040f63fdf6d3af9c36de3fe0414a57a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed862e78c447646f5e701aa3b4527c6d802d37c0b83bcaa4580c3ec1dde6d6b"
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
