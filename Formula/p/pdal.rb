class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.6.1/PDAL-2.6.1-src.tar.bz2"
  sha256 "e421361fe5e1ea63204a3b5c8b654388edbb0fb15c09d24469741e84211ef9d2"
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
    sha256                               arm64_sonoma:   "541b5ffa9e716b62862242fe7c0be610c3b3e557847a4b50e3596c7f2bbdce09"
    sha256                               arm64_ventura:  "d7b162abbd3a7c9b188c2bab82d1da7169e239eca947c9ee42c6692cf125e94e"
    sha256                               arm64_monterey: "d9fa7fc451050554593865c3e3ba99b8b6287fb088e7f2ae9ed8b5b1c7bbaf40"
    sha256                               sonoma:         "7ae5a07d14d44d127e8d95a421375c90aad61a104184dc880a7a2d79ff51c1ce"
    sha256                               ventura:        "03d3715ad89e37435de70425c11579ce11a55230800204e265cab6197e904ac2"
    sha256                               monterey:       "9a6ef933da5e4614a7eb8092b0e33c7e8f72422caa1fb940cdeabc4f6eee46b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527895feeef25d68aaf55dc7d0ea941e899d8359ba472b69d7b70a1dd15dafce"
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

  # fix for https://github.com/PDAL/PDAL/issues/4255, remove in next release
  patch do
    url "https://github.com/PDAL/PDAL/commit/4957980a0b842e502001638c2f15e40b0e2e9aa7.patch?full_index=1"
    sha256 "aa30d3bca2a6e8875e64e03bc29b38c27e4e16ebf8d39a76c2ae42f7380e2d3a"
  end

  # fix for https://github.com/PDAL/PDAL/issues/4258, remove in next release
  patch do
    url "https://github.com/PDAL/PDAL/commit/c0a7d60205fe9599f2ea05e65f45ab5a955c5f6f.patch?full_index=1"
    sha256 "c76639200ca88f1d731d07f4520bfb029efdf3e97c7eb80bd86033caeb5dc95b"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_BACKTRACE=FALSE",
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
