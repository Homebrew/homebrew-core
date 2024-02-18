class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.6.3/PDAL-2.6.3-src.tar.bz2"
  sha256 "e4d90a3ce4c9681cd3522ca29e73a88ff3b3c713f918693ad03932a6b7680460"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https://pdal.io/en/latest/download.html"
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "f55399e6bab66339ed4a238b5496f438d7a18e3103c9798314067641bb3e1b8e"
    sha256                               arm64_ventura:  "a7534bf836be5eae604bc2c613d1b18c9eb19a5fbd74688e4772133d7d27cfef"
    sha256                               arm64_monterey: "239a1a53b59c0b7363f71899e493518f81ee22aa643ed0eb0d843ce745fca15e"
    sha256                               sonoma:         "d049ca0eab141477047e1bf470ada1d073cbae3bfb8b6056a7bde5565002c12c"
    sha256                               ventura:        "7dee3c43b2978a80990dcc7aab48820f137e1cabbc0bf1d3491b70491f421907"
    sha256                               monterey:       "c59403a91924762b18eed85de7fd4971a3c720bd9f256e4263bf33f9d13b1aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e8be40cfad7935652651d5e8856650c328b74d96d7989107116689f839ea95"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"
  depends_on "openssl@3"

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
