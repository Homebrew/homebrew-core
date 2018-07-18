class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "http://www.gdal.org/"
  url "https://download.osgeo.org/gdal/2.3.1/gdal-2.3.1.tar.xz"
  sha256 "9c4625c45a3ee7e49a604ef221778983dd9fd8104922a87f20b99d9bedb7725a"
  revision 1

  bottle do
    sha256 "8fd9f4bea010ab1a734b9e93e7768ba1232929f0c55584e55f4a0f518933edd2" => :high_sierra
    sha256 "b4a94d1d2cb9944db72ceacf3eae46b16ffedd0e23690d993f877962b1496899" => :sierra
    sha256 "0329fd8ff5722be6e43b4e16ed56ff71096f5464e76141dd633c08a553eb31d4" => :el_capitan
  end

  head do
    url "https://svn.osgeo.org/gdal/trunk/gdal"
    depends_on "doxygen" => :build
  end

  option "with-complete", "Use additional Homebrew libraries to provide more drivers."
  option "with-unsupported", "Allow configure to drag in any library it can find. Invoke this at your own risk."

  deprecated_option "enable-unsupported" => "with-unsupported"
  deprecated_option "complete" => "with-complete"

  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "json-c"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "numpy"
  depends_on "pcre"
  depends_on "proj"
  depends_on "python"
  depends_on "python@2"
  depends_on "sqlite" # To ensure compatibility with SpatiaLite

  depends_on "mysql" => :optional

  if build.with? "complete"
    depends_on "cfitsio"
    depends_on "epsilon"
    depends_on "hdf5"
    depends_on "jasper"
    depends_on "json-c"
    depends_on "libdap"
    depends_on "libxml2"
    depends_on "netcdf"
    depends_on "podofo"
    depends_on "poppler"
    depends_on "unixodbc" # macOS version is not complete enough
    depends_on "webp"
    depends_on "xerces-c"
    depends_on "xz" # get liblzma compression algorithm library from XZutils
  end

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
      "--with-bsb",
      "--with-grib",
      "--with-pam",
      "--with-pcidsk=internal",
      "--with-pcraster=internal",

      # Homebrew backends
      "--with-curl=/usr/bin/curl-config",
      "--with-freexl=#{Formula["freexl"].opt_prefix}",
      "--with-geos=#{Formula["geos"].opt_prefix}/bin/geos-config",
      "--with-geotiff=#{Formula["libgeotiff"].opt_prefix}",
      "--with-gif=#{Formula["giflib"].opt_prefix}",
      "--with-jpeg=#{Formula["jpeg"].opt_prefix}",
      "--with-libjson-c=#{Formula["json-c"].opt_prefix}",
      "--with-libtiff=#{Formula["libtiff"].opt_prefix}",
      "--with-pg=#{Formula["libpq"].opt_prefix}/bin/pg_config",
      "--with-png=#{Formula["libpng"].opt_prefix}",
      "--with-spatialite=#{Formula["libspatialite"].opt_prefix}",
      "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
      "--with-static-proj4=#{Formula["proj"].opt_prefix}",

      # Explicitly disable some features
      "--without-grass",
      "--without-jpeg12",
      "--without-libgrass",
      "--without-perl",
      "--without-php",
      "--without-python",
      "--without-ruby",
      "--with-armadillo=no",
      "--with-qhull=no",
    ]

    if build.with?("mysql")
      args << "--with-mysql=#{Formula["mysql"].opt_prefix}/bin/mysql_config"
    else
      args << "--without-mysql"
    end

    # Optional Homebrew packages supporting additional formats
    supported_backends = %w[liblzma cfitsio hdf5 netcdf jasper xerces odbc
                            dods-root epsilon webp podofo]
    if build.with? "complete"
      supported_backends.delete "liblzma"
      args << "--with-liblzma=yes"
      args.concat supported_backends.map { |b| "--with-" + b + "=" + HOMEBREW_PREFIX }
    elsif build.without? "unsupported"
      args.concat supported_backends.map { |b| "--without-" + b }
    end

    # Unsupported backends are either proprietary or have no compatible version
    # in Homebrew. Podofo is disabled because Poppler provides the same
    # functionality and then some.
    unsupported_backends = %w[gta ogdi fme hdf4 openjpeg fgdb ecw kakadu mrsid
                              jp2mrsid mrsid_lidar msg oci ingres dwgdirect
                              idb sde podofo rasdaman sosi]
    if build.without? "unsupported"
      args.concat unsupported_backends.map { |b| "--without-" + b }
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.stable? # GDAL 2.3 handles Python differently
      cd "swig/python" do
        system "python3", *Language::Python.setup_install_args(prefix)
        system "python2", *Language::Python.setup_install_args(prefix)
      end
      bin.install Dir["swig/python/scripts/*.py"]
    end

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
    if build.stable? # GDAL 2.3 handles Python differently
      system "python3", "-c", "import gdal"
      system "python2", "-c", "import gdal"
    end
  end
end
