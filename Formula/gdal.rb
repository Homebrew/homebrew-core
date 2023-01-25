class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.6.2/gdal-3.6.2.tar.xz"
  sha256 "35f40d2e08061b342513cdcddc2b997b3814ef8254514f0ef1e8bc7aa56cf681"
  license "MIT"
  revision 2

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8beabf423f7ede547c70ec9e15e8820d050bea5ddd6fcee8603da6698daedd54"
    sha256 arm64_monterey: "4be1d4d93cfe37e92ffb0154294973436792461d94a46ffefae52a1854087f08"
    sha256 arm64_big_sur:  "725dbdd5c9a4d570c272c5e13680de69c5599402ac815b18def81e07a8f9e524"
    sha256 ventura:        "070d728eec7f1e54f2a4cd72febe40e6732895b5ffbb0497fa65c8f7faec2da4"
    sha256 monterey:       "47470b63c1558380dedba05391a98c60dc7a92ed807a32d97c48379c44e221ca"
    sha256 big_sur:        "1d7deadedd4c8fb2d06eb7f1c07b627f68dd8f92f759d113728daa97254093e7"
    sha256 x86_64_linux:   "88246ece8cde173cac78d30415d54a80814c92e37091571dc3a74a1634968166"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "cfitsio"
  depends_on "epsilon"
  depends_on "expat"
  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-c"
  depends_on "libdap"
  depends_on "libgeotiff"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "pcre2"
  depends_on "poppler"
  depends_on "proj"
  depends_on "python@3.11"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  conflicts_with "avce00", because: "both install a cpl_conv.h header"
  conflicts_with "cpl", because: "both install cpl_error.h"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "swig/python/CMakeLists.txt",
              /(set\(INSTALL_ARGS "--single-version-externally-managed --record=record.txt")\)/,
              "\\1 --install-lib=#{prefix/Language::Python.site_packages(python3)})"

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_PYTHON_BINDINGS=ON",
                    "-DPython_EXECUTABLE=#{which(python3)}",
                    "-DENABLE_PAM=ON",
                    "-DCMAKE_INSTALL_RPATH=#{lib}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # basic tests to see if third-party dylibs are loading OK
    system bin/"gdalinfo", "--formats"
    system bin/"ogrinfo", "--formats"
    # Changed Python package name from "gdal" to "osgeo.gdal" in 3.2.0.
    system python3, "-c", "import osgeo.gdal"
  end
end
