class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://gdal.org/en/stable/"
  url "https://github.com/OSGeo/gdal/releases/download/v3.13.3/gdal-3.13.3.tar.gz"
  sha256 "5e0c388d83da2d686cc00a40272882432cdb54edff43d4af173e532844a0a0ea"
  license "MIT"
  revision 1
  compatibility_version 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "3a107d130ee62736cfe7676c58752d13aceccfb6b285c9030948d3febe417146"
    sha256 arm64_sequoia: "94f1c075a4f487139d9781eea0c61242c90d5854ad76dafa94fa0a0cd258191f"
    sha256 arm64_sonoma:  "71bde058a7e323f089f452cc58f57832bf0d927b5cdfb653190743003451c280"
    sha256 arm64_linux:   "9ad76e2fb6f93989ef52b20e38e395529fe3744a27d4ddd336411dc3564af949"
    sha256 x86_64_linux:  "cb1d03dabed46e7bccebe2e6602f075d47a7eb19b4479250ae3d933a42762aff"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "ant" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "apache-arrow"
  depends_on "c-blosc"
  depends_on "cfitsio"
  depends_on "epsilon"
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
  depends_on "python@3.14"
  depends_on "qhull"
  depends_on "sfcgal"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "expat", since: :sequoia

  on_macos do
    depends_on "minizip"
    depends_on "uriparser"
  end

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "avce00", because: "both install a cpl_conv.h header"
  conflicts_with "cpl", because: "both install cpl_error.h"

  # One `extra_compile_args` list is shared by every `Extension`, so `-std=c++11` also hits C-only `_gdalconst`.
  patch do
    url "https://github.com/OSGeo/gdal/commit/f68c6ba6551f67dbc6b18e9461b197711283dd87.patch?full_index=1"
    sha256 "b4b502b4a0988bb438bb7e5bb40d21ac0c148afb1a7c90aaf1a78b92e9e4cb4d"
    type :unofficial
    resolves "https://github.com/OSGeo/gdal/pull/15042"
  end

  def python3 = "python3.14"

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
      -DGDAL_USE_OPENMP=OFF
    ]

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
