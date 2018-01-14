class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https://postgis.net/"
  url "http://download.osgeo.org/postgis/source/postgis-2.4.2.tar.gz"
  sha256 "23625bc99ed440d53a20225721095a3f5c653b62421c4d597c8038f0d7a321d9"
  revision 1

  bottle do
    cellar :any
    sha256 "a50a389b003c6cf040786f83ddfd9bd48d406bf593fa6faee6db596ae68526df" => :high_sierra
    sha256 "697b94a98dcbc8c8cc6b0d9d8c04e93813f6308bae41a0d76eb41537eab39c55" => :sierra
    sha256 "8d2cd66ab51858995b4660f963a2d46fa4272c93508ffb5c1cf9c6720e59dd46" => :el_capitan
  end

  head do
    url "https://svn.osgeo.org/postgis/trunk/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-gui", "Build shp2pgsql-gui in addition to command line tools"
  option "without-gdal", "Disable postgis raster support"
  option "with-html-docs", "Generate multi-file HTML documentation"
  option "with-api-docs", "Generate developer API documentation (long process)"
  option "with-protobuf-c", "Build with protobuf-c to enable Geobuf and Mapbox Vector Tile support"

  depends_on "pkg-config" => :build
  depends_on "gpp" => :build
  depends_on "postgresql"
  depends_on "proj"
  depends_on "geos"

  depends_on "gtk+" if build.with? "gui"

  # For GeoJSON and raster handling
  depends_on "json-c"
  depends_on "gdal" => :recommended
  depends_on "pcre" if build.with? "gdal"

  # For advanced 2D/3D functions
  depends_on "sfcgal" => :recommended

  if build.with? "html-docs"
    depends_on "imagemagick"
    depends_on "docbook-xsl"
  end

  if build.with? "api-docs"
    depends_on "graphviz"
    depends_on "doxygen"
  end

  depends_on "protobuf-c" => :optional

  def install
    ENV.deparallelize

    args = [
      "--with-projdir=#{Formula["proj"].opt_prefix}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",
      "--with-pgconfig=#{Formula["postgresql"].opt_bin}/pg_config",
      # Unfortunately, NLS support causes all kinds of headaches because
      # PostGIS gets all of its compiler flags from the PGXS makefiles. This
      # makes it nigh impossible to tell the buildsystem where our keg-only
      # gettext installations are.
      "--disable-nls",
    ]

    args << "--with-gui" if build.with? "gui"
    args << "--without-raster" if build.without? "gdal"
    args << "--with-xsldir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl" if build.with? "html-docs"
    args << "--with-protobufdir=#{Formula["protobuf-c"].opt_bin}" if build.with? "protobuf-c"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"

    if build.with? "html-docs"
      cd "doc" do
        ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
        system "make", "chunked-html"
        doc.install "html"
      end
    end

    if build.with? "api-docs"
      cd "doc" do
        system "make", "doxygen"
        doc.install "doxygen/html" => "api"
      end
    end

    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    bin.install Dir["stage/**/bin/*"]
    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
    (doc/"postgresql/extension").install Dir["stage/**/share/doc/postgresql/extension/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
    pkgshare.install Dir["stage/**/contrib/postgis-*/*"]
    (share/"postgis_topology").install Dir["stage/**/contrib/postgis_topology-*/*"]

    # Extension scripts
    bin.install %w[
      utils/create_undef.pl
      utils/postgis_proc_upgrade.pl
      utils/postgis_restore.pl
      utils/profile_intersects.pl
      utils/test_estimation.pl
      utils/test_geography_estimation.pl
      utils/test_geography_joinestimation.pl
      utils/test_joinestimation.pl
    ]

    man1.install Dir["doc/**/*.1"]
  end

  def caveats
    <<~EOS
      To create a spatially-enabled database, see the documentation:
        https://postgis.net/docs/manual-2.4/postgis_installation.html#create_new_db_extensions
      If you are currently using PostGIS 2.0+, you can go the soft upgrade path:
        ALTER EXTENSION postgis UPDATE TO "#{version}";
      Users of 1.5 and below will need to go the hard-upgrade path, see here:
        https://postgis.net/docs/manual-2.4/postgis_installation.html#upgrading

      PostGIS SQL scripts installed to:
        #{opt_pkgshare}
      PostGIS plugin libraries installed to:
        #{HOMEBREW_PREFIX}/lib
      PostGIS extension modules installed to:
        #{HOMEBREW_PREFIX}/share/postgresql/extension
      EOS
  end

  test do
    require "base64"
    (testpath/"brew.shp").write ::Base64.decode64 <<~EOS
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoOgDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAEAAAASCwAAAAAAAAAAAPA/AAAAAAAA8D8AAAAAAAAA
      AAAAAAAAAAAAAAAAAgAAABILAAAAAAAAAAAACEAAAAAAAADwPwAAAAAAAAAA
      AAAAAAAAAAAAAAADAAAAEgsAAAAAAAAAAAAQQAAAAAAAAAhAAAAAAAAAAAAA
      AAAAAAAAAAAAAAQAAAASCwAAAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAAAAA
      AAAAAAAAAAAABQAAABILAAAAAAAAAAAAAAAAAAAAAAAUQAAAAAAAACJAAAAA
      AAAAAEA=
    EOS
    (testpath/"brew.dbf").write ::Base64.decode64 <<~EOS
      A3IJGgUAAABhAFsAAAAAAAAAAAAAAAAAAAAAAAAAAABGSVJTVF9GTEQAAEMA
      AAAAMgAAAAAAAAAAAAAAAAAAAFNFQ09ORF9GTEQAQwAAAAAoAAAAAAAAAAAA
      AAAAAAAADSBGaXJzdCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgIFBvaW50ICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgU2Vjb25kICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICBQb2ludCAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgIFRoaXJkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgUG9pbnQgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICBGb3VydGggICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgIFBvaW50ICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgQXBwZW5kZWQgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgICBQb2ludCAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAg
    EOS
    (testpath/"brew.shx").write ::Base64.decode64 <<~EOS
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARugDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAADIAAAASAAAASAAAABIAAABeAAAAEgAAAHQAAAASAAAA
      igAAABI=
    EOS
    result = shell_output("#{bin}/shp2pgsql #{testpath}/brew.shp")
    assert_match /Point/, result
    assert_match /AddGeometryColumn/, result
  end
end
