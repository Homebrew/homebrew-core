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
    sha256 arm64_monterey: "65769ba2cb7f1313a735c2fd515cf286ae3ceb823734e60881f52aa410b8023d"
    sha256 arm64_big_sur:  "e60a5c2ba1b023d78c238ad1e01131ff5ba1aab26ad168c9ece60a64efdf571b"
    sha256 monterey:       "f3df8b0aa4884651da6b2d7969ab3956c87c5be7ffdbf84ec1dac4a51ee36c2b"
    sha256 big_sur:        "245777c47ac3cfecf7161c9769635f7b9946c16d54e7919bc05d36cf351f4424"
    sha256 catalina:       "98a4bb40444a2b46a15c7f65c2962e78cfd342f45158265e0a16ef2ae2bc7324"
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
