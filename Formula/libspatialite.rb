class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

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
    sha256 cellar: :any,                 arm64_monterey: "0a2b9cbcf782fb1550dcb5524a61ca69ec22a2cbbb426506b418b9fe9138e4b6"
    sha256 cellar: :any,                 arm64_big_sur:  "dc8b7f36b4f7aba60fdb088ec17ca69bddb353fed99a1e6d0200590a0ee0adb2"
    sha256 cellar: :any,                 monterey:       "ef04ad217e063418d0d404c66c9621de3fc3bfd1c9b8a55d4b512dca9c534ff4"
    sha256 cellar: :any,                 big_sur:        "f740afb58268b4babe07a123e1b7857b754abea2ffced3b37b8edf7140408652"
    sha256 cellar: :any,                 catalina:       "abf71f3882743f1bebf560c66a0f211f0298f0498ed0093b29d1feaa6c5c425f"
    sha256 cellar: :any,                 mojave:         "64a4c76c3cc6aa7ae20c510a4688182af14bb9f1da38bed1409dcd6a1a333a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e92d770bacb404f5e3573b8353ed78735fcb618f93dc070d220a9e9413700eb"
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
