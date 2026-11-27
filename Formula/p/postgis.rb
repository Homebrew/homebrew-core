class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-3.7.0.tar.gz"
  sha256 "832bbf50f2b6f57fab053bc9676b3bfe641e5bf966cdcb28c7926f8d4b3c5e04"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 2

  livecheck do
    url "https://download.osgeo.org/postgis/source/"
    regex(/href=.*?postgis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "38de9730e25a79d26f62522201008b2b4df956347edf16e4e9915973b3676a24"
    sha256 cellar: :any, arm64_golden_gate: "2f1b9274adde3ae5b09e919d926aa7b62a18c328818fc6462da83aa775dcb400"
    sha256 cellar: :any, arm64_tahoe:       "4f77712e7ce00b697325f79378c905070cad295fc0cc41695f3b542712719ea9"
    sha256 cellar: :any, arm64_sequoia:     "3e0e225813f837b098e9b4886df6e83967306a0b73d77d08213071dfd5bc3011"
    sha256 cellar: :any, arm64_linux:       "820375324dab8f12786ebb1973563d866611384f1958b00241a2ac0506803f81"
    sha256 cellar: :any, x86_64_linux:      "d903bee5848976f685fa56e942acbb1b6b264f7cad4645c0fb955a849a580873"
  end

  head do
    url "https://git.osgeo.org/gitea/postgis/postgis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgresql@19" => [:build, :test]

  depends_on "gdal"
  depends_on "geos"
  depends_on "gmp"
  depends_on "icu4c@79"
  depends_on "json-c"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "pcre2"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "sfcgal"

  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  def postgresqls
    deps(/\Apostgresql@/).map(&:to_formula).sort_by(&:version)
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    # C++17 is required.
    ENV.append "CXXFLAGS", "-std=c++17"
    # Avoid linking to libc++ on Linux due to indirect LLVM dependency
    ENV["ac_cv_lib_cpp_main"] = "no" if OS.linux?

    bin.mkpath
    system "./autogen.sh" if build.head?

    postgresqls.each do |postgresql|
      # PostGIS' build system assumes it is being installed to the same place as
      # PostgreSQL, and looks for the `postgres` binary relative to the
      # installation `bindir`. We gently support this system using an illusion.
      #
      # PostGIS links against the `postgres` binary for symbols that aren't
      # exported in the public libraries `libpgcommon.a` and similar, so the
      # build will break with confusing errors if this is omitted.
      #
      # See: https://github.com/NixOS/nixpkgs/commit/330fff02a675f389f429d872a590ed65fc93aedb
      bin.install_symlink postgresql.opt_bin/"postgres"

      mkdir "build-pg#{postgresql.version.major}" do
        system "../configure", "--with-projdir=#{formula_opt_prefix("proj")}",
                               "--with-jsondir=#{formula_opt_prefix("json-c")}",
                               "--with-pgconfig=#{postgresql.opt_bin}/pg_config",
                               "--with-protobufdir=#{formula_opt_bin("protobuf-c")}",
                               *std_configure_args
        # Force `bin/pgsql2shp` to link to `libpq`
        system "make", "PGSQL_FE_CPPFLAGS=-I#{formula_opt_include("libpq")}",
                       "PGSQL_FE_LDFLAGS=-L#{formula_opt_lib("libpq")} -lpq"
        # Override the hardcoded install paths set by the PGXS makefiles
        system "make", "install", "bindir=#{bin}",
                                  "docdir=#{doc}",
                                  "mandir=#{man}",
                                  "pkglibdir=#{lib}/#{postgresql.name}",
                                  "datadir=#{share}/#{postgresql.name}",
                                  "PG_SHAREDIR=#{share}/#{postgresql.name}"
      end

      rm(bin/"postgres")
    end

    # Extension scripts
    bin.install %w[
      utils/create_upgrade.pl
      utils/profile_intersects.pl
      utils/test_estimation.pl
      utils/test_geography_estimation.pl
      utils/test_geography_joinestimation.pl
      utils/test_joinestimation.pl
    ]
  end

  test do
    ENV["LC_ALL"] = "C"
    (testpath/"brew.shp").write <<~EOS.unpack1("m")
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoOgDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAEAAAASCwAAAAAAAAAAAPA/AAAAAAAA8D8AAAAAAAAA
      AAAAAAAAAAAAAAAAAgAAABILAAAAAAAAAAAACEAAAAAAAADwPwAAAAAAAAAA
      AAAAAAAAAAAAAAADAAAAEgsAAAAAAAAAAAAQQAAAAAAAAAhAAAAAAAAAAAAA
      AAAAAAAAAAAAAAQAAAASCwAAAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAAAAA
      AAAAAAAAAAAABQAAABILAAAAAAAAAAAAAAAAAAAAAAAUQAAAAAAAACJAAAAA
      AAAAAEA=
    EOS
    (testpath/"brew.dbf").write <<~EOS.unpack1("m")
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
    (testpath/"brew.shx").write <<~EOS.unpack1("m")
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARugDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAADIAAAASAAAASAAAABIAAABeAAAAEgAAAHQAAAASAAAA
      igAAABI=
    EOS

    result = shell_output("#{bin}/shp2pgsql #{testpath}/brew.shp")
    assert_match "Point", result
    assert_match "geometry(POINTZM,0)", result

    postgresqls.each do |postgresql|
      pg_version = postgresql.version.major
      expected = /'PostGIS built for PostgreSQL % cannot be loaded in PostgreSQL %',\s+#{pg_version}\.\d,/
      postgis_version = version.major_minor
      assert_match expected, (share/postgresql.name/"contrib/postgis-#{postgis_version}/postgis.sql").read

      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~CONF, mode: "a+"

        shared_preload_libraries = 'postgis-3'
        port = #{port}
        unix_socket_directories = '#{testpath}'
      CONF
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION \"postgis\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
