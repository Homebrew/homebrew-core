class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.1/PDAL-2.4.1-src.tar.gz"
  sha256 "4df8463f68087e3742691048f5ab9db04269fc54bc418e4dc53e2c761bd825f2"
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
    sha256                               arm64_monterey: "4c517edad1925969b63af40be4b62abf2fe09db4e23f58c7369c4ec170c60b3c"
    sha256                               arm64_big_sur:  "3c429f9cef115fb4035a5af4490e95b6ac6a323bcd8dcb66f63c33db0d029ef6"
    sha256                               monterey:       "0906017a6a0b9ef2fcd0765891ce6d135a0323798b6ebd25fc5e719a3d4e8b93"
    sha256                               big_sur:        "85d1b7e2657be04f9a1c14f3de1657dec459ed5e41a193da9119fb213bf4aecb"
    sha256                               catalina:       "83c87ef72f93fcb3a6aa974f1c399c083ad90f36ba52553be6cb8bc4d3dabb91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eddcef5404e65c93ac07197c06415fb9fc93176fc58cf135afcd53c063c9239"
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
