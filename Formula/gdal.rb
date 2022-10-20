class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.5.2/gdal-3.5.2.tar.xz"
  sha256 "0874dfdeb9ac42e53c37be4184b19350be76f0530e1f4fa8004361635b9030c2"
  license "MIT"
  revision 1

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9650161a67c3eeebdedac886dddcd9001ff2ee059cce4298d410d5a79bb11295"
    sha256 arm64_big_sur:  "6e28dd2d941702ce7872ae0b0fdd535bae7e9a4580d2762cf1c7d213f1d258ac"
    sha256 monterey:       "7ed6d18a6f7bac3469a521e359d402ecd62139bee89b256e0a00f72c5a1635e0"
    sha256 big_sur:        "25f3da385cca97c8ce1cceaea00ae9c5ef7eb3bfce0af542c52991d6b0b18063"
    sha256 catalina:       "f631b92c445609673d837580dd71fbfee49a3f8b465889112fddafde4184dee1"
    sha256 x86_64_linux:   "aa426be6ba32fea8a3fdc2072651ce2aaeda7ee3dcb6d1522353fe69f1803ef2"
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
  depends_on "jpeg-turbo"
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
      "--with-jpeg=#{Formula["jpeg-turbo"].opt_prefix}",
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
      args << (Hardware::CPU.arm? ? "--without-opencl" : "--with-opencl")
    else
      args << "--with-curl=#{Formula["curl"].opt_bin}/curl-config"

      # The python build needs libgdal.so, which is located in .libs
      ENV.append "LDFLAGS", "-L#{buildpath}/.libs"
      # The python build needs gnm headers, which are located in the gnm folder
      ENV.append "CFLAGS", "-I#{buildpath}/gnm"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Build Python bindings
    cd "swig/python" do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end
    bin.install buildpath.glob("swig/python/scripts/*.py")

    system "make", "man" if build.head?
    # Force man installation dir: https://trac.osgeo.org/gdal/ticket/5092
    system "make", "install-man", "INST_MAN=#{man}"
    # Clean up any stray doxygen files
    bin.glob("*.dox").map(&:unlink)
  end

  test do
    # basic tests to see if third-party dylibs are loading OK
    system bin/"gdalinfo", "--formats"
    system bin/"ogrinfo", "--formats"
    # Changed Python package name from "gdal" to "osgeo.gdal" in 3.2.0.
    system python3, "-c", "import osgeo.gdal"
  end
end
