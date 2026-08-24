class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://gdal.org/en/stable/"
  url "https://github.com/OSGeo/gdal/releases/download/v3.13.3/gdal-3.13.3.tar.gz"
  sha256 "5e0c388d83da2d686cc00a40272882432cdb54edff43d4af173e532844a0a0ea"
  license "MIT"
  compatibility_version 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "de88d6090f36405661f17c6958710e26ab6e1234a6369c2d3edb220e801223f7"
    sha256 arm64_sequoia: "b5bd7be5f0fc49779221aa059e0d3d9ed94c8fd5c950a5526061e058c79b7a65"
    sha256 arm64_sonoma:  "c68f9d113dc25c2721dc34c531fc8ddf8c587aa525443b63511d8e887e01187a"
    sha256 sonoma:        "7d54ca478264c4e19e3900e419d1960994d5a204cd6c2a180e2e9257cf134af6"
    sha256 arm64_linux:   "a169b8c33497549ca6be8d1845a250b900f28cb7cdf1672d34a9ffc32317ce3a"
    sha256 x86_64_linux:  "8710628014480cf80f64e74bab3716ac37704f612d3005ff7556f462e46ba845"
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
  uses_from_macos "expat"

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

  def python3
    "python3.14"
  end

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(formula_opt_prefix("expat"))}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    remove_brew_expat if OS.mac? && MacOS.version < :sequoia

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
