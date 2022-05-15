class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.0/PDAL-2.4.0-src.tar.gz"
  sha256 "c08e56c0d3931ab9e612172d5836673dfa2d5e6b2bf4f8d22c912b126b590b15"
  license "BSD-3-Clause"
  revision 4
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
    sha256                               arm64_monterey: "60adcdce893074c077feed906fdc37eff3fd490bac6817691e44003486d9e59c"
    sha256                               arm64_big_sur:  "7f6b74bbc10baa540756d992dd74af1d4865638b7c402ee8002461bb6ca42baa"
    sha256                               monterey:       "acfcf85ae15a0be32dcaabf6641303b3d2a66e41c412faa690da649cdbdf73d9"
    sha256                               big_sur:        "dff0336342ab6f61963635cd86fd264f928fabfdcf320fd7122a0da1d5b097e8"
    sha256                               catalina:       "c65305bd9e3378019a324d75e38cce6ba60c78dfce8606d815b262c20e092463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f739ad0a0756f1a61bbe3a413b0d1efffa4bd020e43a6b6d8cec31dcc0c3a09"
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
