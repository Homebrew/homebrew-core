class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.0/PDAL-2.4.0-src.tar.gz"
  sha256 "c08e56c0d3931ab9e612172d5836673dfa2d5e6b2bf4f8d22c912b126b590b15"
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
    sha256 arm64_monterey: "8b2d3dd5e4390a118e9e35980cef058f079ba3a0d1e25ccbd753f3d322e65870"
    sha256 arm64_big_sur:  "724be1381656a8f68eb38d2380d998801e94103a11a7a1b08fddc294c570c5c1"
    sha256 monterey:       "f839188c4a7a921115f1cc1e044d13206472cfb32bd06ebafe5d13269143227c"
    sha256 big_sur:        "0a6c761f34ba44be7fa15ef1c08c7129940a8a848bfcd898fec8d7665f2e3990"
    sha256 catalina:       "cc81422d2d7108f16bc0f0262781caa633b299afd6f6bab3cc0bfd8a841a5eb3"
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
