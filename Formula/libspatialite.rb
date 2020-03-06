class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  revision 8

  stable do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.3.0a.tar.gz"
    mirror "https://ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-4.3.0a.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-4.3.0a.tar.gz"
    sha256 "88900030a4762904a7880273f292e5e8ca6b15b7c6c3fb88ffa9e67ee8a5a499"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/27a0e51936e01829d0a6f3c75a7fbcaf92bb133f/libspatialite/sqlite310.patch"
      sha256 "459434f5e6658d6f63d403a7795aa5b198b87fc9f55944c714180e7de662fce2"
    end
  end

  bottle do
    cellar :any
    sha256 "e8bd429119857fab4cb51f3ba7b64024b51eb2400873e71fc9d6aad297c109ce" => :catalina
    sha256 "8fcc2ccaf861f94c3fb41b1c6435e86f52a7fe70e66d9e02a5acb16d285c4360" => :mojave
    sha256 "a77ac13e3758d389ccf42fa62d8a7bb528062c215e2b380b8d3df7211696712f" => :high_sierra
  end

  head do
    url "https://www.gaia-gis.it/fossil/libspatialite", :using => :fossil
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libxml2"
  depends_on "proj"
  # Needs SQLite > 3.7.3 which rules out system SQLite on Snow Leopard and
  # below. Also needs dynamic extension support which rules out system SQLite
  # on Lion. Finally, RTree index support is required as well.
  depends_on "sqlite"

  def install
    system "autoreconf", "-fi" if build.head?

    # New SQLite3 extension won't load via SELECT load_extension("mod_spatialite");
    # unless named mod_spatialite.dylib (should actually be mod_spatialite.bundle)
    # See: https://groups.google.com/forum/#!topic/spatialite-users/EqJAB8FYRdI
    #      needs upstream fixes in both SQLite and libtool
    inreplace "configure",
              "shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'",
              "shrext_cmds='.dylib'"
    chmod 0755, "configure"

    # Ensure Homebrew's libsqlite is found before the system version.
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib}"
    ENV.append "CFLAGS", "-I#{sqlite.opt_include}"

    # Use Proj 6.0.0 compatibility headers.
    # Remove in libspatialite 5.0.0
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-sysroot=#{HOMEBREW_PREFIX}
      --enable-geocallbacks
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Verify mod_spatialite extension can be loaded using Homebrew's SQLite
    pipe_output("#{Formula["sqlite"].opt_bin}/sqlite3",
      "SELECT load_extension('#{opt_lib}/mod_spatialite');")
  end
end
