class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-5.0.1.tar.gz"
  mirror "https://ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-5.0.1.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-5.0.1.tar.gz"
  sha256 "eecbc94311c78012d059ebc0fae86ea5ef6eecb13303e6e82b3753c1b3409e98"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/"
    regex(/href=.*?libspatialite[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "18ecddab7cd064038e15a9e023fc1cb94dfabcb4ea1dbd527e19754c80829445"
    sha256 cellar: :any, big_sur:       "eea8b32b264f5183558158fe3d76cfd676bb731620f67fc1da66519f28171b6b"
    sha256 cellar: :any, catalina:      "054c1286dcdffded43a8cf768eac32c4f20e9870bc0b0e0aa04c40fb31280836"
    sha256 cellar: :any, mojave:        "c136e8503fda01a139f00fbc6ac5e3b24989961a17485c28e231b355090e98e4"
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
  depends_on "proj@7"
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
