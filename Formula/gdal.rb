class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.6.2/gdal-3.6.2.tar.xz"
  sha256 "35f40d2e08061b342513cdcddc2b997b3814ef8254514f0ef1e8bc7aa56cf681"
  license "MIT"
  revision 4

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a09caa6cd22ac96250419ecbde02872fdecc702a8bf1bfc6d5fded6c2b61276f"
    sha256 arm64_monterey: "d2532b7324a6a9bf5ee69cdb137f2bdd742650876a0d45a5b70e90c709178a90"
    sha256 arm64_big_sur:  "2f5577e416507e97326f9201c53fff03490ea3413b8432861b350302f1f328b6"
    sha256 ventura:        "23d0a19c201d33b6f1d1fc015341b32e86f9a9bc1af8d185fe928b8ab5afb754"
    sha256 monterey:       "807ef51b603b7a6677c70c8087da02d1a83a89f57d6b1be2952de651c3b069c3"
    sha256 big_sur:        "b90886dc07fdfd4e8c6cbf74bedf4ce0b1baa2005b94a3f787f8de8ac26dc642"
    sha256 x86_64_linux:   "48d9c5dcba2417194cc0ddc1cff846cb6621efa3cb5953a57cc96b50aa462ecf"
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
