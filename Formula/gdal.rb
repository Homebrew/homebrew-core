class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.6.2/gdal-3.6.2.tar.xz"
  sha256 "35f40d2e08061b342513cdcddc2b997b3814ef8254514f0ef1e8bc7aa56cf681"
  license "MIT"
  revision 3

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "64ef5c12d62208554fdbd203ca99ff39c1a3ebf3ed1106a96d1c02cbe6ec9be2"
    sha256 arm64_monterey: "1123bc885963f60054d0348f1e21dbeac500c280a6cdcd52ab7adf68da4543ee"
    sha256 arm64_big_sur:  "e85ea7c692117837ca4abb541c6781b128912553bc82140f5af93f2cd44b496b"
    sha256 ventura:        "34513c179da299d3e2dd2116b0afc92a296ced09f69858cbccdac213d21aea87"
    sha256 monterey:       "4550547ce3d84bc2ad4dc221b1fdd5eda5a4d9620e1690874093e78566075c20"
    sha256 big_sur:        "e3a708fc99b86ca5a654c6183afc3b65e9d282917e1e0d4aedb2627b5c1ebb00"
    sha256 x86_64_linux:   "ceb0b3e1fc5814f5f88ec175fd98414125978bed39b024f4d45f105900401793"
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
  depends_on "liblerc"
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
  depends_on "qhull"
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

    # keep C++ standard in sync with `abseil.rb`
    args = %W[
      -DENABLE_PAM=ON
      -DBUILD_PYTHON_BINDINGS=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DPython_EXECUTABLE=#{which(python3)}
      -DCMAKE_CXX_STANDARD=17
    ]

    # JavaVM.framework in SDK causing Java bindings to be built
    args << "-DBUILD_JAVA_BINDINGS=OFF" if MacOS.version <= :catalina

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
