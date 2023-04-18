class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2

  stable do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-5.0.1.tar.gz"
    mirror "https://ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-5.0.1.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-5.0.1.tar.gz"
    sha256 "eecbc94311c78012d059ebc0fae86ea5ef6eecb13303e6e82b3753c1b3409e98"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/"
    regex(/href=.*?libspatialite[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e899d02886f31301ebd4c65a0fbf56237ea49ddb3f1468437204ea567b94d75"
    sha256 cellar: :any,                 arm64_monterey: "8dc0901eff2763a59d1ddc22f3ed19ef1a1b706ba2d4069a092e1c86e730db91"
    sha256 cellar: :any,                 arm64_big_sur:  "bdc286c42eb9dcead8e145ae385f4764cc6b081b4284388749b3e0ee270b4431"
    sha256 cellar: :any,                 ventura:        "c4e86af4b415b091cb0e53a49236b67079b0fe61d0be81e2202e9f0657826fbc"
    sha256 cellar: :any,                 monterey:       "87c4d5eedbd6657e5bbb5f02c64f82dd9d7de502c57fecd44a2059cdff476724"
    sha256 cellar: :any,                 big_sur:        "001ef9d46fb1b508459bf5a1aac259643def005b8fb808663dd32e49c89cff5a"
    sha256 cellar: :any,                 catalina:       "d403ece87a9d8349fc2bad142f52b1c44c423cc17fbc7da5ee3f2a2a168dd796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7936163e48b970c168ccd0b53d917b47364d91b4698aed7cd1199858d0e30b8"
  end

  head do
    url "https://www.gaia-gis.it/fossil/libspatialite", using: :fossil
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "librttopo"
  depends_on "libxml2"
  depends_on "minizip"
  depends_on "proj"
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

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-sysroot=#{HOMEBREW_PREFIX}
      --enable-geocallbacks
      --enable-rttopo=yes
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
