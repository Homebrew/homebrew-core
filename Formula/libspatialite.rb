class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  revision 6

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
    sha256 "f1aaaa0bec4ec6b2c636139e391b2fc17e71e9ccad5588aba9362cb89bbb4729" => :mojave
    sha256 "2a41b0baab67ec8b35f3c68b392439907a1b003a84437b8437b3ca3ecdcf35f4" => :high_sierra
    sha256 "4b73791b59c7766a4e20d9ca77502d2866f7d07fb7aeba660bf38e41077ba60e" => :sierra
    sha256 "eff5f3de6139cfe0adff6ec2fe306c7f11ee1f7b9195089d514902b11b0675d0" => :el_capitan
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

    # Ensure Homebrew's libsqlite is found before the system version.
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib}"
    ENV.append "CFLAGS", "-I#{sqlite.opt_include}"

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
