class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "https://download.osgeo.org/gdal/3.4.3/gdal-3.4.3.tar.xz"
  sha256 "02a27b35899e1c4c3bcb6007da900128ddd7e8ab7cd6ccfecf338a301eadad5a"
  license "MIT"
  revision 1

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "08bd830e8630985f41520f68b9caf8d5cc55669780665117603f0cd8bab91f8f"
    sha256 arm64_big_sur:  "69b07480370918f266dadf03b2faaf8f58d41cf41b307c46b42bac665ad7b0cf"
    sha256 monterey:       "c190dd7f0a4647cefb342f1fde6ae029bf57aaa7a359c6a61626c5b6e2c92813"
    sha256 big_sur:        "eacb12e285df0415254913f04d37ac77c9a4695c8de14fdb403312607040a9c3"
    sha256 catalina:       "da07300e9738770bcb3980230d2add0d5defcc0015a664d7fd660f1b5441afac"
    sha256 x86_64_linux:   "b23dd8e5f4a98fcf76803a69703aef0c4ba7d4185a1c7e198d786fc7ce3159bf"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "epsilon"
  depends_on "expat"
  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "json-c"
  depends_on "libdap"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "openjpeg"
  depends_on "pcre2"
  depends_on "poppler-qt5"
  depends_on "proj"
  depends_on "python@3.9"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
    depends_on "gcc"
  end

  conflicts_with "avce00", because: "both install a cpl_conv.h header"
  conflicts_with "cpl", because: "both install cpl_error.h"

  fails_with gcc: "5"

  def install
    args = [
      # Base configuration
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--disable-debug",
      "--with-libtool",
      "--with-local=#{prefix}",
      "--with-threads",

      # GDAL native backends
      "--with-pam",
      "--with-pcidsk=internal",
      "--with-pcraster=internal",

      # Homebrew backends
      "--with-expat=#{Formula["expat"].prefix}",
      "--with-freexl=#{Formula["freexl"].opt_prefix}",
      "--with-geos=#{Formula["geos"].opt_prefix}/bin/geos-config",
      "--with-geotiff=#{Formula["libgeotiff"].opt_prefix}",
      "--with-gif=#{Formula["giflib"].opt_prefix}",
      "--with-jpeg=#{Formula["jpeg"].opt_prefix}",
      "--with-libjson-c=#{Formula["json-c"].opt_prefix}",
      "--with-libtiff=#{Formula["libtiff"].opt_prefix}",
      "--with-pg=yes",
      "--with-png=#{Formula["libpng"].opt_prefix}",
      "--with-spatialite=#{Formula["libspatialite"].opt_prefix}",
      "--with-pcre2=yes",
      "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
      "--with-proj=#{Formula["proj"].opt_prefix}",
      "--with-zstd=#{Formula["zstd"].opt_prefix}",
      "--with-liblzma=yes",
      "--with-cfitsio=#{Formula["cfitsio"].opt_prefix}",
      "--with-hdf5=#{Formula["hdf5"].opt_prefix}",
      "--with-netcdf=#{Formula["netcdf"].opt_prefix}",
      "--with-openjpeg",
      "--with-xerces=#{Formula["xerces-c"].opt_prefix}",
      "--with-odbc=#{Formula["unixodbc"].opt_prefix}",
      "--with-dods-root=#{Formula["libdap"].opt_prefix}",
      "--with-epsilon=#{Formula["epsilon"].opt_prefix}",
      "--with-webp=#{Formula["webp"].opt_prefix}",
      "--with-poppler=#{Formula["poppler"].opt_prefix}",

      # Explicitly disable some features
      "--with-armadillo=no",
      "--with-qhull=no",
      "--without-exr",
      "--without-grass",
      "--without-jasper",
      "--without-jpeg12",
      "--without-libgrass",
      "--without-mysql",
      "--without-perl",
      "--without-python",

      # Unsupported backends are either proprietary or have no compatible version
      # in Homebrew. Podofo is disabled because Poppler provides the same
      # functionality and then some.
      "--without-ecw",
      "--without-fgdb",
      "--without-fme",
      "--without-gta",
      "--without-hdf4",
      "--without-idb",
      "--without-ingres",
      "--without-jp2mrsid",
      "--without-kakadu",
      "--without-mrsid",
      "--without-mrsid_lidar",
      "--without-msg",
      "--without-oci",
      "--without-ogdi",
      "--without-podofo",
      "--without-rasdaman",
      "--without-sde",
      "--without-sosi",
    ]

    if OS.mac?
      args << "--with-curl=/usr/bin/curl-config"
      args << "--with-opencl"
    else
      args << "--with-curl=#{Formula["curl"].opt_bin}/curl-config"

      # The python build needs libgdal.so, which is located in .libs
      ENV.append "LDFLAGS", "-L#{buildpath}/.libs"
      # The python build needs gnm headers, which are located in the gnm folder
      ENV.append "CFLAGS", "-I#{buildpath}/gnm"
    end

    ENV.append "CXXFLAGS", "-std=c++17" # poppler-qt5 uses std::optional
    system "./configure", *args
    system "make"
    system "make", "install"

    # Build Python bindings
    cd "swig/python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
    bin.install Dir["swig/python/scripts/*.py"]

    system "make", "man" if build.head?
    # Force man installation dir: https://trac.osgeo.org/gdal/ticket/5092
    system "make", "install-man", "INST_MAN=#{man}"
    # Clean up any stray doxygen files
    Dir.glob("#{bin}/*.dox") { |p| rm p }
  end

  test do
    # basic tests to see if third-party dylibs are loading OK
    system "#{bin}/gdalinfo", "--formats"
    system "#{bin}/ogrinfo", "--formats"
    # Changed Python package name from "gdal" to "osgeo.gdal" in 3.2.0.
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import osgeo.gdal"
  end
end
