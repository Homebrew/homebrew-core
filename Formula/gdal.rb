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
    sha256 arm64_ventura:  "68818443a3b73c6f992ea9385a7719a650e717a2c62558cc41ab9b94dd3c44da"
    sha256 arm64_monterey: "6feb0d2796a7819c73de82e603a8c35052a5643be8ceea8702d9bffa6e2f5ad9"
    sha256 arm64_big_sur:  "73e2d3f993598fc08fa1ddd4e474f43d339523ccf5f75e9ef0d7c9b1ad9a244e"
    sha256 ventura:        "ae69349026277eac66c50f43889f917db2382cfc648fb44fcc013acc0929d639"
    sha256 monterey:       "07e8854ebdf402eae4f30cf02ceb56c31ff62b244a14aa185234fea81943ad0a"
    sha256 big_sur:        "004583d3f9452726af7799635f7461435c005ca33d4a4eef3b7ff59288249be9"
    sha256 x86_64_linux:   "b17aba9701031a2ad83668fcf5184bd5ee202e68150141de625dfb47ab4c7f6c"
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

    args = %W[
      -DENABLE_PAM=ON
      -DBUILD_PYTHON_BINDINGS=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DPython_EXECUTABLE=#{which(python3)}
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
