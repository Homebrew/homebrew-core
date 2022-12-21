class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.6.1/gdal-3.6.1.tar.xz"
  sha256 "68f1c03547ff7152289789db7f67ee634167c9b7bfec4872b88406b236f9c230"
  license "MIT"

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "304ae53da0f58717968108fd0954e505ba6c0ceac796f2a73680462bde66e244"
    sha256 arm64_monterey: "6c56b6a3357a7469dbcc734aa9d9986fe02ec5b10fb5c115d4142856d101d2f0"
    sha256 arm64_big_sur:  "8c170834628981b839c3b8ec8b8237d34d08ad0ae03b010f1f072e38d7f0ee15"
    sha256 ventura:        "4194f540b67ba64f358e0a0d355132c69e27542004db787a7c05e5f188119175"
    sha256 monterey:       "239e28458448dc50cd4d7ee7119b6a1d8c0a2807f16ba19976eaa7bdc8e1678c"
    sha256 big_sur:        "afa1902f5e69c25f59876d85915baeaa2af3df8df74dbf8bf619fab1d16eb0c6"
    sha256 x86_64_linux:   "d0ba3e8b774392d316f8415191c4d6f91a07a0d1337dbda6402c126488cc62ca"
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
