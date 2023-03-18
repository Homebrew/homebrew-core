class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.6.3/gdal-3.6.3.tar.xz"
  sha256 "3cccbed883b1fb99b913966aa3a650ad930e7c3afc714f5823f9754176ee49ea"
  license "MIT"

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ad7e8a3e9d31de5c5a55d7c53252f9d457a1f1a625321c21fcb0a56df0ae4896"
    sha256 arm64_monterey: "ffeaa3544f3412c5c9b3419bc345f1b51b622e861705eccabbeba67767f43821"
    sha256 arm64_big_sur:  "4f50866b76da2cb0e2d2c795e3e18614592b9cd857529ba9d228d81135536a34"
    sha256 ventura:        "67af60fac733bdbac1db3e8817be46939955c9a1c25b59d21b1699833f573192"
    sha256 monterey:       "c476400fedf4272e95c08d675ad6b09f31a42e7632c2508c6bbe3f690a3cf959"
    sha256 big_sur:        "0f0dd45ae1a213958ecc78cd4b8c19cead2b5cef61230f4468ed3362d4524f4d"
    sha256 x86_64_linux:   "d041fede7d6a8565397ba4c5cae6e5910729a9a22aa6b4dfe29d7f18ebf646b0"
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
