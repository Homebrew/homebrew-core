class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "https://download.osgeo.org/gdal/2.3.2/gdal-2.3.2.tar.xz"
  sha256 "3f6d78fe8807d1d6afb7bed27394f19467840a82bc36d65e66316fa0aa9d32a4"

  bottle do
    sha256 "97c2b47f65141cc67949dc49fc7fdd0972e34d9ac9b21b7c14b27816220facc3" => :mojave
    sha256 "c5d1c451b34740f1759a66d6b1af4a159ded520309d6613c73e7d9d4040e392d" => :sierra
  end

  head do
    url "https://github.com/OSGeo/gdal.git"
    depends_on "doxygen" => :build
  end

  option "with-complete", "Compile support for more drivers."

  deprecated_option "complete" => "with-complete"

  depends_on "expat"
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
  depends_on "zstd"

  if build.with? "complete"
    depends_on "cfitsio"
    depends_on "epsilon"
    depends_on "hdf5"
    depends_on "jasper"
    depends_on "libdap"
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
      "--with-expat=#{Formula["expat"].prefix}",
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
      "--with-zstd=#{Formula["zstd"].opt_prefix}",

      # Explicitly disable some features
      "--with-armadillo=no",
      "--with-qhull=no",
      "--without-grass",
      "--without-jpeg12",
      "--without-libgrass",
      "--without-mysql",
      "--without-perl",
      "--without-php",
      "--without-python",
      "--without-ruby",
    ]

    # Optional Homebrew packages supporting additional formats
    supported_backends = %w[cfitsio hdf5 netcdf jasper xerces odbc
                            dods-root epsilon webp podofo]
    if build.with? "complete"
      args << "--with-liblzma=yes"
      args.concat supported_backends.map { |b| "--with-" + b + "=" + HOMEBREW_PREFIX }
    else
      args.concat supported_backends.map { |b| "--without-" + b }
    end

    # Unsupported backends are either proprietary or have no compatible version
    # in Homebrew. Podofo is disabled because Poppler provides the same
    # functionality and then some.
    unsupported_backends = %w[gta ogdi fme hdf4 openjpeg fgdb ecw kakadu mrsid
                              jp2mrsid mrsid_lidar msg oci ingres dwgdirect
                              idb sde podofo rasdaman sosi]
    args.concat unsupported_backends.map { |b| "--without-" + b }

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

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
