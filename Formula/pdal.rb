class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.5.5/PDAL-2.5.5-src.tar.bz2"
  sha256 "b32b16475619a6bdfaee5a07a9b859206e18de5acff2a4447502fd0a9c6538d6"
  license "BSD-3-Clause"
  revision 2
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
    sha256                               arm64_ventura:  "f981ddf7b857dab47c9f442e82f35a3412ac2777177c3a7c2265cb93a9a4635c"
    sha256                               arm64_monterey: "5a2c82cec3f85e2209ffbebc50443b17f3beb271fca736e6650b240c736774bb"
    sha256                               arm64_big_sur:  "b231f6b2efab96a6b427f4f6bf15f3c98e79493d76a53f4b55d4c5b77a9e0384"
    sha256                               ventura:        "62d13386e761fc30876ffec0b0465df084075e86f500e385ad7bacad286d9d35"
    sha256                               monterey:       "bd3cc32bb5b6ac7c038418243e0b068f0097d7b97e6868eb0f0c4ece73aed246"
    sha256                               big_sur:        "24df412bcd84c58f61f36f51bdbbbe8a2ca8d361c4ff6ae7fd5e3b8e9f14ecac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3537bb96f559c55153245920a67173513435401f505a26d05b70df0e74ac49ba"
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
