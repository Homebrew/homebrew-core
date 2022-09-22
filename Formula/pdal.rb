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
    rebuild 1
    sha256                               arm64_monterey: "27cd33bae8c8eba42f1745f47575d9bd3194063ef898cd6c3f500205e8718c55"
    sha256                               arm64_big_sur:  "047036bece13c2c6177574729a8efb2312ded09895e9e9a178dd0c70adb913ae"
    sha256                               monterey:       "75afee346e430fe3dcf6042482c7325ddec2b9dbc8a0aa18c6208860cbfcb7ba"
    sha256                               big_sur:        "bdc5415e581f7f054abfd4484b11a45ce4de6958a2e90256ee9089834f8156c3"
    sha256                               catalina:       "23cd4314c4097b66a55aa553da7eea5ebde1b24aac90a08a0d15bcb6b3614aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca526ebb3a39b85ba26d3b74429fa3bc74cb55bb4d4d9ae8e1c9832c0c93e5d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"

  fails_with gcc: "5" # gdal is compiled with GCC

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
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
