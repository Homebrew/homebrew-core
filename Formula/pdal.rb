class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://github.com/PDAL/PDAL/releases/download/2.5.3/PDAL-2.5.3-src.tar.bz2"
    sha256 "1d193e9cf11766a394722e1899d6a7d1fb81387af113250beff58e6325851b13"

    # Fix build with GDAL 3.7+
    patch do
      url "https://github.com/PDAL/PDAL/commit/516e33ad7f40e54affd5754617fbe26d70ef2dd4.patch?full_index=1"
      sha256 "f434773b1454766df3213be46312f7712c5b6ec74fe12986f77fa3d2f393cc6d"
    end
  end

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
    sha256                               arm64_ventura:  "5fd2d55cb0b811be8e4bf38e9659caac8ac203c2b1c9b52bd7d49b7745433131"
    sha256                               arm64_monterey: "52a31e04c96984b218bd5e8dfcf1a5ebc71c197b5c7a26387435fd9a86bc2d85"
    sha256                               arm64_big_sur:  "51fbd3620688b88b6512c5f96bf8f6e9a9e807c6f3e1e7226f3e6278d53e2e42"
    sha256                               ventura:        "69da38e2e9dddbf4d7a0ab76d218180b508ffaf52f38e7800d50d0baa7bfb163"
    sha256                               monterey:       "ce97064bdb6e8bcecb98ad48cbfb93f9609692b7a314a10e100fd9b1d24200f9"
    sha256                               big_sur:        "3a50b50f67c7a60771b75f7465c51a581c741f06f907f2830356a74bfc524d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "958eee5fa9d78c3b3253834968c12257f1d11f7a1bd430ae00f6367ce6033d4e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"

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
