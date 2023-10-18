class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  stable do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-5.1.0.tar.gz"
    mirror "https://ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-5.1.0.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-5.1.0.tar.gz"
    sha256 "43be2dd349daffe016dd1400c5d11285828c22fea35ca5109f21f3ed50605080"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/"
    regex(/href=.*?libspatialite[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2b131baa2cff3e6c1797baec3d6e3307af41074f3cd836328c86b328935b0de"
    sha256 cellar: :any,                 arm64_ventura:  "93ad60cc9ec55d4f4472d83bf9775d2e1d75fc6d23b3cdf891086057bc76e465"
    sha256 cellar: :any,                 arm64_monterey: "cd54cba79354b17f2a3d0b367a1cf0863ce134ce7441b4ec5b8538f6e51a2cf0"
    sha256 cellar: :any,                 arm64_big_sur:  "51e6aa08cb016ed1b348cb7d4cdbddf43f5f99d0a21958eb8272b635df732c61"
    sha256 cellar: :any,                 sonoma:         "bd2eed8c377d2e0e2894d2a62de0ed80428287bdbf4e2ff96fe197055f8d6db7"
    sha256 cellar: :any,                 ventura:        "3baa41829944e9b089682dd3d4d96cd4a68d67d1a4668e935ad2387e626c196e"
    sha256 cellar: :any,                 monterey:       "384f5f1304cf4dfd32e0a59e8c4669f5534a043cab13791d6dc56f696230d407"
    sha256 cellar: :any,                 big_sur:        "1957739657a713ca553b78e3a9a7ac4626a50af9db64d207d5d2487a2df95de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a0a7b3bf5bd73224b24abefa5a0f709c4c6fd832d4868cf6fedf213a73971fd"
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
