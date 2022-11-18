class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.6.0/gdal-3.6.0.tar.xz"
  sha256 "f7afa4aa8d32d0799e011a9f573c6a67e9471f78e70d3d0d0b45b45c8c0c1a94"
  license "MIT"

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1e0323894a7beeec3cc7f294642a76d97286053447a3cb6f2a958905b25952cd"
    sha256 arm64_monterey: "8a1820762677f86c073a6316b1e3d10a7b52f7bd506f46e7fdc4f0d66e74a671"
    sha256 arm64_big_sur:  "54e081fd4cf018a35eac7d1cf61ed7b4b3784335fa72c46430df9c15bd3e1a77"
    sha256 ventura:        "85e6d537e381369228eace8265a57f08953ebc1c916089e345f9c263aa761b7a"
    sha256 monterey:       "c0bd2c214d494f099865a4ca597601f8b920a6bca0bdee658c7e1b5a69d9ce08"
    sha256 big_sur:        "f4c81256295ca2b05c3a7c1853c1e36b9246ec4a200b03317acdfcc29182e090"
    sha256 x86_64_linux:   "d73631a76aa2e5a32aebdbdc822d4d2dcd74462a44c71a5e18cabde3a3d21504"
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
  depends_on "python@3.10"
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
    "python3.10"
  end

  def install
    args = [
      "-DENABLE_PAM=ON",
      "-DCMAKE_INSTALL_RPATH=#{lib}",
    ]
    args.concat(std_cmake_args)
    args_no_python = args.dup << "-DBUILD_PYTHON_BINDINGS=OFF"

    mkdir "build" do
      # First, build without Python to avoid a Linux issue where the
      # Python bindings are installed in the wrong path
      # See https://github.com/Homebrew/homebrew-core/pull/116073#issuecomment-1320875424
      system "cmake", "..", *args_no_python
      system "make"
      system "make", "install"

      # Next, reconfigure with Python and manually run the python build
      args_with_python = args.dup << "-DBUILD_PYTHON_BINDINGS=ON"
      system "cmake", "..", *args_with_python
      system "make"

      # Build Python bindings
      cd "swig/python" do
        system python3, *Language::Python.setup_install_args(prefix, python3)
      end
    end
  end

  test do
    # basic tests to see if third-party dylibs are loading OK
    system bin/"gdalinfo", "--formats"
    system bin/"ogrinfo", "--formats"
    # Changed Python package name from "gdal" to "osgeo.gdal" in 3.2.0.
    system python3, "-c", "import osgeo.gdal"
  end
end
