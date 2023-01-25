class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.3/PDAL-2.4.3-src.tar.gz"
  sha256 "abac604c6dcafdcd8a36a7d00982be966f7da00c37d89db2785637643e963e4c"
  license "BSD-3-Clause"
  revision 5
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
    sha256                               arm64_ventura:  "b145597a2bc716cbcbaf26d84decccb036ec13b128660ed75650a0b1d701ddca"
    sha256                               arm64_monterey: "da9093b3d6f58a288c57d1881655d8ff40eda857fe64927d04dcdb123f638289"
    sha256                               arm64_big_sur:  "9eff84edbe30ac408fd28f0903af506ae6864a0b108d6ed5c32bb726292751b1"
    sha256                               ventura:        "8aace20f820b6f384a629d003ff9a868ab7b65ce93342d1da0db7a4cad9fa97a"
    sha256                               monterey:       "c8e4d8faebdb46f9e9884f4a84dc58fc5cc82ec15e86ec6b70a2c5d860b55d72"
    sha256                               big_sur:        "4862f29cfc6f7778ba3427cab71d77598830f178b196edb61827321f9940bd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2eea1807baa6fd1a77cf2068b8b42853188fc20b38fdf4073285633a2d4819"
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
