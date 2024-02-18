class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  license "MIT"
  revision 2

  stable do
    url "https://github.com/OSGeo/gdal/releases/download/v3.8.3/gdal-3.8.3.tar.gz"
    sha256 "f7a30387a8239e9da26200f787a02136df2ee6473e86b36d05ad682761a049ea"

    # remove with next release
    patch do
      url "https://github.com/OSGeo/gdal/commit/ca2eb4130750b0e6365f738a5f8ff77081f5c5bb.patch?full_index=1"
      sha256 "5d6ae9c555a8e01a25176a17e66602752ee5e9b158c76be82f14b937b179e433"
    end
  end

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "c98dfbefb77289cf75d2091b448a2de2810640bd7a663e85dc41c834e0ad282a"
    sha256 arm64_ventura:  "e1efa8c18dafa24a1012700fefc3b7e7466d801fd826391399a1f220b2863630"
    sha256 arm64_monterey: "2b01adbc04ee00c33bbf43a501993db159471c951590cc91c601c11c87deb310"
    sha256 sonoma:         "234f8c0f6c8024b1d03e5a2cb9601131baad82225294b1e20e414ddcd0704e5e"
    sha256 ventura:        "f927cf631d27668aa7ffa35cb7904cbbb2df5dd5a5afa51923f0028b638a62f2"
    sha256 monterey:       "d12f2d441f2c8c6d997d5c87169975cacfa5e368e4d2c6e100c788fc3c93219c"
    sha256 x86_64_linux:   "963ab123a7d5e9c3bd06b7f3c7c245ef650f485b9551a55cb1158e9bdfbdfce2"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "boost" => :build # for `libkml`
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
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
  depends_on "python@3.12"
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
    "python3.12"
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
  end
end
