class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.3/PDAL-2.4.3-src.tar.gz"
  sha256 "abac604c6dcafdcd8a36a7d00982be966f7da00c37d89db2785637643e963e4c"
  license "BSD-3-Clause"
  revision 4
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
    sha256                               arm64_ventura:  "7337a95cde479ef4c077fe7b11ab5827659e6a9eaabad8bbb1564b1fec46e8e2"
    sha256                               arm64_monterey: "ffa58effd207f9009cea9aa6af1dfb7f6ab838e1b3c6e901367c8338d68a2ae5"
    sha256                               arm64_big_sur:  "99afb417f1c3e91f3943eb13ef46d90fca62a5ac08a8b6990b5a65d96ef60593"
    sha256                               ventura:        "42467d416923a024ea1332e950f98b33b16f84b759a166c4c00c8e66ab93f038"
    sha256                               monterey:       "9bf267ff88813b901de3fc44c1cb485eede891936e8594ae6dab94a93ee78f51"
    sha256                               big_sur:        "bd743612466ca19436dc355b403315e45381e6598246319fe2a40cf9055d9db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bafbfe6bc8408b97af48830b9cb3f9fd3e0adbad4aa5384ca97fde746018403a"
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
