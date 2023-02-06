class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.5.0/PDAL-2.5.0-src.tar.gz"
  sha256 "5eab602af7003be84935fae3548a6e7018a4b4a6d8f8812c845847eea33239d2"
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
    sha256                               arm64_ventura:  "6efce087c245991d4843a4c4649db05ffdcbf7b059016e88a7a9c3fe92871ef0"
    sha256                               arm64_monterey: "9f26c0343cc0bf96c4815ccbc040f9b03fdc5ad462a4b86a46c50dc7f440b77d"
    sha256                               arm64_big_sur:  "17367be0a40f8531deba7e466024ad94462340b1eddc52411e07763572b96010"
    sha256                               ventura:        "c6089581421ab6da3cda4173ee0be1fa73aad9a7fd26650b39975187866695e7"
    sha256                               monterey:       "b7dd199aec4e4af7ddd17b85d8626b031a4578215a6d550c64341a6078a1f2f0"
    sha256                               big_sur:        "9038d24e9ecba22eb1310630bd56e3f9261b5142e5c0df449cc9a30c3c7aa472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88234cbbf72d1e730fb8af5d79bbc8f2ceb45f5a856d3eb429096ee3eced234a"
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
