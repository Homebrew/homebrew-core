class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-3.4.2.tar.gz"
  sha256 "c8c874c00ba4a984a87030af6bf9544821502060ad473d5c96f1d4d0835c5892"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://download.osgeo.org/postgis/source/"
    regex(/href=.*?postgis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "e0014c18cb6b3dde857c539db4e6c2d9497d0593d07bf6317f6b397887681621"
    sha256 cellar: :any,                 arm64_ventura:  "3e81f29471b5f120f6a025ae9d84aae78f7f45832d28d1fd09be44db21032958"
    sha256 cellar: :any,                 arm64_monterey: "9cc65c4f6488229db1291868937b6ac4e52b31e478e9309e49b45380cd498e01"
    sha256 cellar: :any,                 sonoma:         "6032c5c5ff4e402b4eb0a7e22998c3c0565c130acd8a2703b6f517e6ac0b86e5"
    sha256 cellar: :any,                 ventura:        "16ca9d88fa312c18ec3709ef6b4b12569fc24bdea6878bd6aa892c94cebb4bc0"
    sha256 cellar: :any,                 monterey:       "1e4fae0c7a6adc454e8d8f4211146956dc16a4813a0ed084910e731b7163d442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49464e51526bcab6a49cae922f46e0020c55c4ba6341008eca687f290fada5ab"
  end

  head do
    url "https://git.osgeo.org/gitea/postgis/postgis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gpp" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal" # for GeoJSON and raster handling
  depends_on "geos"
  depends_on "icu4c"
  depends_on "json-c" # for GeoJSON and raster handling
  depends_on "pcre2"
  depends_on "postgresql@14"
  depends_on "proj"
  depends_on "protobuf-c" # for MVT (map vector tiles) support
  depends_on "sfcgal" # for advanced 2D/3D functions

  fails_with gcc: "5" # C++17

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    ENV.deparallelize

    # C++17 is required.
    ENV.append "CXXFLAGS", "-std=c++17"

    # Workaround for: Built-in generator --c_out specifies a maximum edition
    # PROTO3 which is not the protoc maximum 2023.
    # Remove when fixed in `protobuf-c`:
    # https://github.com/protobuf-c/protobuf-c/pull/711
    ENV["PROTOCC"] = Formula["protobuf"].opt_bin/"protoc"

    # PostGIS' build system assumes it is being installed to the same place as
    # PostgreSQL, and looks for the `postgres` binary relative to the
    # installation `bindir`. We gently support this system using an illusion.
    #
    # PostGIS links against the `postgres` binary for symbols that aren't
    # exported in the public libraries `libpgcommon.a` and similar, so the
    # build will break with confusing errors if this is omitted.
    #
    # See: https://github.com/NixOS/nixpkgs/commit/330fff02a675f389f429d872a590ed65fc93aedb
    bin.mkpath
    ln_s "#{postgresql.opt_bin}/postgres", "#{bin}/postgres"

    args = [
      "--with-projdir=#{Formula["proj"].opt_prefix}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",
      "--with-pgconfig=#{postgresql.opt_bin}/pg_config",
      "--with-protobufdir=#{Formula["protobuf-c"].opt_bin}",
      # Unfortunately, NLS support causes all kinds of headaches because
      # PostGIS gets all of its compiler flags from the PGXS makefiles. This
      # makes it nigh impossible to tell the buildsystem where our keg-only
      # gettext installations are.
      "--disable-nls",
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    # Override the hardcoded install paths set by the PGXS makefiles
    system "make", "install", "bindir=#{bin}",
                              "docdir=#{doc}",
                              "mandir=#{man}",
                              "pkglibdir=#{lib/postgresql.name}",
                              "datadir=#{share/postgresql.name}",
                              "PG_SHAREDIR=#{share/postgresql.name}"

    rm "#{bin}/postgres"

    # Extension scripts
    bin.install %w[
      utils/create_upgrade.pl
      utils/postgis_restore.pl
      utils/profile_intersects.pl
      utils/test_estimation.pl
      utils/test_geography_estimation.pl
      utils/test_geography_joinestimation.pl
      utils/test_joinestimation.pl
    ]
  end

  test do
    pg_version = postgresql.version.major
    expected = /'PostGIS built for PostgreSQL % cannot be loaded in PostgreSQL %',\s+#{pg_version}\.\d,/
    postgis_version = Formula["postgis"].version.major_minor
    assert_match expected, (share/postgresql.name/"contrib/postgis-#{postgis_version}/postgis.sql").read

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

    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'postgis-3'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"postgis\";", "postgres"
    system pg_ctl, "stop", "-D", testpath/"test"
  end
end
