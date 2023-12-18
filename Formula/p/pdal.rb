class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.6.2/PDAL-2.6.2-src.tar.bz2"
  sha256 "4ec3d128af4d15924ddac91ddac56335cf32897c743349460cfa41d51f0f9e4e"
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
