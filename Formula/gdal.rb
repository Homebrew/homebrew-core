class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.6.2/gdal-3.6.2.tar.xz"
  sha256 "35f40d2e08061b342513cdcddc2b997b3814ef8254514f0ef1e8bc7aa56cf681"
  license "MIT"
  revision 1

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d08762b512461dee51727b5f9039f8f7cda24f45af98f079a394c886d69d796e"
    sha256 arm64_monterey: "57ee5af7856afd3d7de3c9100826e7a564b2aad8f7baca123da52d55d6eeab46"
    sha256 arm64_big_sur:  "5b51bb6dfc5d237ed7d2309dc2d893565479a6d3106de8206bf2e9eab271a087"
    sha256 ventura:        "a4fec61bbc5ac86eabd4c06d2b86a961a26d05ab8983a131e07772356a74c483"
    sha256 monterey:       "6d3c327fb8482acaa12a4532dd0193b044e36a58161b54e18c6ff72ca0482a8f"
    sha256 big_sur:        "f2bf6ce3f81043819dde60f065428c64a9fadd92f0b892669874b888a713973f"
    sha256 x86_64_linux:   "7e3f364f934ddc0048563a3085a4d10bb962d233806ce235dc6284b6ae87d398"
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
