class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-3.6.1.tar.gz"
  sha256 "ec0cfaab475630106211d180d71df46782e41e10b6dffe91d79ca818ecd2cbb4"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://download.osgeo.org/postgis/source/"
    regex(/href=.*?postgis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d30ff7262adbaf4a37f3637dc77fff6637574154e25069b4ff3dfc75d51241fe"
    sha256 cellar: :any,                 arm64_sequoia: "f123ccaae8397cb49e35406963b0772a962c92042d2b23738fe7db9960e218b2"
    sha256 cellar: :any,                 arm64_sonoma:  "89dadbbd91a12afa5f6ebbd74179cf4ad6434cebaa367aacc737d72f77ebb335"
    sha256 cellar: :any,                 sonoma:        "1908b9db23bcb1468084d3a04adaf3c0bf689c32e124eb34dd106e25436e0b65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd5095f7d81ec4715d581de3285e12300edf57e1ce38651ef3cc554650db88a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d6b7526fdfee008feaa17b7ed0d5551f65f40c4af230d4ac7ddaabbb3d5af3"
  end

  head do
    url "https://git.osgeo.org/gitea/postgis/postgis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  depends_on "gdal"
  depends_on "geos"
  depends_on "icu4c@78"
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
    deps.filter_map { |dep| dep.to_formula if dep.name.start_with?("postgresql@") }
        .sort_by(&:version)
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
        system "../configure", "--with-projdir=#{Formula["proj"].opt_prefix}",
                               "--with-jsondir=#{Formula["json-c"].opt_prefix}",
                               "--with-pgconfig=#{postgresql.opt_bin}/pg_config",
                               "--with-protobufdir=#{Formula["protobuf-c"].opt_bin}",
                               *std_configure_args
        # Force `bin/pgsql2shp` to link to `libpq`
        system "make", "PGSQL_FE_CPPFLAGS=-I#{Formula["libpq"].opt_include}",
                       "PGSQL_FE_LDFLAGS=-L#{Formula["libpq"].opt_lib} -lpq"
        # Override the hardcoded install paths set by the PGXS makefiles
        system "make", "install", "bindir=#{bin}",
                                  "docdir=#{doc}",
                                  "mandir=#{man}",
                                  "pkglibdir=#{lib/postgresql.name}",
                                  "datadir=#{share/postgresql.name}",
                                  "PG_SHAREDIR=#{share/postgresql.name}"
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
    assert_match "Point", result
    assert_match "AddGeometryColumn", result

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
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'postgis-3'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"postgis\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
