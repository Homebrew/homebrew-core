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
    sha256                               arm64_monterey: "2cc2d40e46a6ba825e7433a891dda892aa99f096ad9f4a7bbe5e579181be1c82"
    sha256                               arm64_big_sur:  "de708dfbb95cd7909f75bb248d5b277f69c6b40c8866ff177609d7f76c64b7b1"
    sha256                               monterey:       "479ad24653ab0f409e4d450e4a960937e83aa982ebed5957594b09cb2d656886"
    sha256                               big_sur:        "f78507d9035a9ff5ad7f4b124c0af86a9b99c8a0ccc2ee55324067b7b8cc8fb2"
    sha256                               catalina:       "e0bfb84ef816bad5e47a63d7ab82335c3dcdaf4e776217d01d71debf92184937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06958cd3f681635b2ec5501394d63326c3c84b7b768c439414b35dcdfb508ece"
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
