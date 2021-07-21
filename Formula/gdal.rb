class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "https://download.osgeo.org/gdal/3.3.1/gdal-3.3.1.tar.xz"
  sha256 "48ab00b77d49f08cf66c60ccce55abb6455c3079f545e60c90ee7ce857bccb70"
  license "MIT"
  revision 2

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "4b2f6161d15671b511aab4892c00aeb98c1508de4166ecda236ecd85e782c83e"
    sha256 big_sur:       "7e5ba2dfcf0a525034bcddb77e2fe8706d7cc4c19a966c1dae20537bb8c93ecc"
    sha256 catalina:      "24a207ad19ffacb02faebbfb3b3dee94099d576873f7b4340fab1c617a970132"
    sha256 mojave:        "f75e12fe0ae2dd60cc9fdd2a14aa5301ceccf53f5c5efec042673514e7ef863a"
  end

  head do
    url "https://github.com/OSGeo/gdal.git"
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
  depends_on "pcre"
  depends_on "poppler-qt5"
  depends_on "proj@7"
  depends_on "python@3.9"
  depends_on "sqlite" # To ensure compatibility with SpatiaLite
  depends_on "unixodbc" # macOS version is not complete enough
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz" # get liblzma compression algorithm library from XZutils
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "bash-completion"
  end

  conflicts_with "avce00", because: "both install a cpl_conv.h header"
  conflicts_with "cpl", because: "both install cpl_error.h"

  def install
    args = [
      # Base configuration
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--disable-debug",
      "--with-libtool",
      "--with-local=#{prefix}",
      "--with-opencl",
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
      "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
      "--with-proj=#{Formula["proj@7"].opt_prefix}",
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

    on_macos do
      args << "--with-curl=/usr/bin/curl-config"
    end
    on_linux do
      args << "--with-curl=#{Formula["curl"].opt_bin}/curl-config"
    end

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
