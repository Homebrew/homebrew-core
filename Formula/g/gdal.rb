class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "https://github.com/OSGeo/gdal/releases/download/v3.7.2/gdal-3.7.2.tar.gz"
  sha256 "fd8aabc63e02bcce2aecc0234af58171b91f478b6111f75b4b236919dac369a5"
  license "MIT"
  revision 1

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "37d7221c1555f7c638c68d86cf201a7abef682f73e275ed3a6509c61eb245e2b"
    sha256 arm64_ventura:  "b4b983f20e0b209e7165a20d15006f77531c0e1465818a0261966c8767d29d26"
    sha256 arm64_monterey: "b7d0efbb7d020faa4bb28c660f6c3324431f43978e23c21ebee5a23ca0b6d629"
    sha256 sonoma:         "24b32311c6585a89ed1736dbf55b9028ee578b0fdf760161ee791dce5875c512"
    sha256 ventura:        "9d26a75e8bf5fdc7adf6c517d726982d0682d6622840aeeee82cac08b5aa3850"
    sha256 monterey:       "c387d01bc780738e7cb76c1b6078c61794b441b04b654eb8ba8decd94a74f512"
    sha256 x86_64_linux:   "81fe52f053888390e25b5866dfe549280d6d6eef6b2385055bb78de57981c707"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "boost" => :build  # for `libkml`
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
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
  depends_on "libarchive"
  depends_on "libgeotiff"
  depends_on "libheif"
  depends_on "libkml"
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
  depends_on "openssl@3"
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
    site_packages = prefix/Language::Python.site_packages(python3)
    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "swig/python/CMakeLists.txt",
              'set(INSTALL_ARGS "--single-version-externally-managed --record=record.txt',
              "\\0 --install-lib=#{site_packages} --install-scripts=#{bin}"

    osgeo_ext = site_packages/"osgeo"
    rpaths = [rpath, rpath(source: osgeo_ext)]
    ENV.append "LDFLAGS", "-Wl,#{rpaths.map { |rp| "-rpath,#{rp}" }.join(",")}"
    # keep C++ standard in sync with `abseil.rb`
    args = %W[
      -DENABLE_PAM=ON
      -DBUILD_PYTHON_BINDINGS=ON
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DPython_EXECUTABLE=#{which(python3)}
      -DGDAL_PYTHON_INSTALL_LIB=#{site_packages}
      -DCMAKE_CXX_STANDARD=17
    ]

    # JavaVM.framework in SDK causing Java bindings to be built
    args << "-DBUILD_JAVA_BINDINGS=OFF" if MacOS.version <= :catalina

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install (share/"bash-completion/completions").children
  end

  test do
    # basic tests to see if third-party dylibs are loading OK
    system bin/"gdalinfo", "--formats"
    system bin/"ogrinfo", "--formats"
    # Changed Python package name from "gdal" to "osgeo.gdal" in 3.2.0.
    system python3, "-c", "import osgeo.gdal"
  end
end
