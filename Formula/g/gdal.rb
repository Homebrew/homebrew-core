class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://gdal.org/en/stable/"
  url "https://github.com/OSGeo/gdal/releases/download/v3.10.2/gdal-3.10.2.tar.gz"
  sha256 "ca710aab81eb4d638f5dbd4f03d4d4b902aeb6ee73a3d4a8c5e966b6b648b0da"
  license "MIT"
  revision 4

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b072fc382816f0b7f347f80f609bd687793a971cc0b7cdfacb766ec276f3b22a"
    sha256 arm64_sonoma:  "6966f6ac9d75730d7a7bc1b19b9b98b2b91778af301a195dafedd716f7c0e600"
    sha256 arm64_ventura: "e8c9383f5383739d7c7b016a036124abbc4d40dc7cef793d6d594492d7cfd6a9"
    sha256 sonoma:        "d503c41a98c279e11abdec8a0081260697113ea4ad958716cfaa13506f855aa5"
    sha256 ventura:       "27762b93addd96a9bd3da257473a2d1d94f699ce6ee106c780dfb835122e9508"
    sha256 x86_64_linux:  "8a5b06d318c635a3f4683d2d22ecc30fee3720dd786c84393bc6c57526304e7f"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "boost" => :build # for `libkml`
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
