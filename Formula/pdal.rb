class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.5.2/PDAL-2.5.2-src.tar.gz"
  sha256 "3966620cbe48c464d70fd5d43fff25596a16abe94abd27d3f48d079fa1ef1f39"
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
    sha256                               arm64_ventura:  "4be59a78327d0d8a150217851b4ee6871a09810df558e5fdf8b4e3e9ed3f1a92"
    sha256                               arm64_monterey: "3ac0e0529278e5f85b0c23434f008a695ebf126804fb01def044f0450896087f"
    sha256                               arm64_big_sur:  "9f82e6546d6f03ebbd7b5b7990426f6340342033d448daefc3809297c7c48f56"
    sha256                               ventura:        "f26b4361af27793de5d3e6ec9e2cca0391dccf8a246509c455f7fa1ae4c7279b"
    sha256                               monterey:       "b846dd8c3949d340a21b991009f22ea637c2c53890e424b9155ee609e75f1cca"
    sha256                               big_sur:        "c6e2ce7796b719f3caaebf4277ec53d9cfb0fc060aa01d0b69c17aeac1b5d404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "999605021ced93e6bca69e14317717b5e94779324d19c9e2bb7380b41de9d9c0"
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
