class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://gdal.org/en/stable/"
  url "https://github.com/OSGeo/gdal/releases/download/v3.11.3/gdal-3.11.3.tar.gz"
  sha256 "54638f6990f84c16142d93c9daaafaf1eab0a6a61538162095c334de086ef91f"
  license "MIT"
  revision 5

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "fea0b9cda334378e06851d5c291df1cbf4ae7e4220610570f157783ad5e4c4d8"
    sha256 arm64_sonoma:  "0ff3c467ebfa62e83b552490211239b0fc01783d6aec69ba2b28842b20541a79"
    sha256 arm64_ventura: "84cf20543815f7e25778455d1cc8814c4c813e5f97449030a76388170287a10d"
    sha256 sonoma:        "210cc7349ee41c49e047b618409c2183465eec4512f0c12227a476549699ecb0"
    sha256 ventura:       "0938d276cb4040177e9dfeeb9638a90f7294446f8d11fc5f63e8d7417f922f42"
    sha256 arm64_linux:   "bdfc2573bc414670d808ca968c126ece02f9adcef3468a16b564c9c2d8fae11c"
    sha256 x86_64_linux:  "b3d4b31c48736a51188ab9c2d92429ca26ce02e58acbbfcc6543a8bc3a147305"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "apache-arrow"
  depends_on "c-blosc"
  depends_on "cfitsio"
  depends_on "epsilon"
  depends_on "expat"
  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "hdf5"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-c"
  depends_on "libaec"
  depends_on "libarchive"
  depends_on "libdeflate"
  depends_on "libgeotiff"
  depends_on "libheif"
  depends_on "libkml"
  depends_on "liblerc"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "lz4"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "poppler"
  depends_on "proj"
  depends_on "python@3.13"
  depends_on "qhull"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "minizip"
    depends_on "uriparser"
  end

  on_linux do
    depends_on "util-linux"
  end

  conflicts_with "avce00", because: "both install a cpl_conv.h header"
  conflicts_with "cpl", because: "both install cpl_error.h"

  def python3
    "python3.13"
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
    args << "-DBUILD_JAVA_BINDINGS=OFF" if OS.mac? && MacOS.version <= :catalina

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
    # test for zarr blosc compressor
    assert_match "BLOSC_COMPRESSORS", shell_output("#{bin}/gdalinfo --format Zarr")
  end
end
