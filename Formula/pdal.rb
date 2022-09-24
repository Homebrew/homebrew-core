class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.3/PDAL-2.4.3-src.tar.gz"
  sha256 "abac604c6dcafdcd8a36a7d00982be966f7da00c37d89db2785637643e963e4c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https://pdal.io/en/stable/download.html"
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    rebuild 2
    sha256                               arm64_monterey: "989f2950a5b60b2d7bf721d17eeb03491ca880906eac1c7c40f6234d8b28c041"
    sha256                               arm64_big_sur:  "b22cc9c4ee859edc32fc5f8f2d5f6da103167669144d97b0a18edb2cae5525a0"
    sha256                               monterey:       "c9abf19402e221b5bf21a981034d4ad4de5f5296e30ecc8e36cf057140273c1c"
    sha256                               big_sur:        "268f007df24c48297c0fd28f5d2ee4855ff8c8b3bb35b3ec3d1cca31614616ee"
    sha256                               catalina:       "287c6d9397052a78ba129cc18b88d99ee9e28eca54c8083e7722319c3e5c3690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5df71e90cc9da1457556655ac22e1ad719c0cef95f024bb37ef7030d9cc3781a"
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
