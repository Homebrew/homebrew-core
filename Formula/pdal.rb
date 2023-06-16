class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.5.5/PDAL-2.5.5-src.tar.bz2"
  sha256 "b32b16475619a6bdfaee5a07a9b859206e18de5acff2a4447502fd0a9c6538d6"
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
    sha256                               arm64_ventura:  "0379d4e1bf9819f1f64f1010c38eeb74f0247fb08b60315b35e6f6d86249a183"
    sha256                               arm64_monterey: "75bd88a737380d163ed0e6d5d6e70306ed7180a375db080ac46c8cc252d2165f"
    sha256                               arm64_big_sur:  "5633fd9e5680eeffd0d3e0409846e51d2bf27af14a28612bd337ae6da0c3c425"
    sha256                               ventura:        "0a95c4451d02287161a210d8848336e073734a9606cfe528c6bdea1ee07be7c8"
    sha256                               monterey:       "fdeae92e945eb48208d967dcd0d02071710aee67afcbd9af29c7c27d1ebcff85"
    sha256                               big_sur:        "57655b4af7ad249cbc332247f5391445ad5f1a382b7ad89119f66aa9bdfcd535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce51a355bfaf2f2aee9f8743b6b8a8738e428747c2ee1d92104a8837c6dedb74"
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
