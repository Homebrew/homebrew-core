class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "http://www.gdal.org/"
  url "https://download.osgeo.org/gdal/2.3.0/gdal-2.3.0.tar.xz"
  sha256 "6f75e49aa30de140525ccb58688667efe3a2d770576feb7fbc91023b7f552aa2"

  bottle do
    rebuild 2
    sha256 "0e40d962b0b81b1bfe8dd8b37e4d252afc85246d1d0ffd6db4be1383d04882f0" => :high_sierra
    sha256 "23d2524542aae03cffff9db10702193028eff35c926cf06fdb7301892ef36ffe" => :sierra
    sha256 "79e367f5eb50209563292f6758b79a1d98ba710bae8639f755f0dcc66f4a205a" => :el_capitan
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
