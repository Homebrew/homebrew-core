class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 4

  stable do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-5.1.0.tar.gz"
    mirror "https://ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-5.1.0.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-5.1.0.tar.gz"
    sha256 "43be2dd349daffe016dd1400c5d11285828c22fea35ca5109f21f3ed50605080"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/"
    regex(/href=.*?libspatialite[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec3bff2150de386d746181a90e8a9a706a5cd0abba9fff83b982f31cec916a93"
    sha256 cellar: :any,                 arm64_sequoia: "587bf2902aaa3908a1dcc76dda6fe5ab38ead02dad6e6bd8f4521c28c0174686"
    sha256 cellar: :any,                 arm64_sonoma:  "d726dbbc340c60fa4aeb0e64f7d84869af74e3ca7a3d0d536b4af8eb53760a51"
    sha256 cellar: :any,                 sonoma:        "ea4844a4718e87cf6dab3f3216fd17f2b227c0f848a91fac80f35ce01c311a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d04b1c9c2e9383f2149bbd1fbc9c6374cdabd8b72887f0d02e17819e06ffdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9080a06cdd748903d3da061c4b50adf0435bf41fd316daf4e86ba145ac9fe47a"
  end

  head do
    url "https://www.gaia-gis.it/fossil/libspatialite", using: :fossil
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "librttopo"
  depends_on "libxml2"
  depends_on "minizip"
  depends_on "proj"
  depends_on "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply Debian patch to allow disabling the usage of removed libxml2 HTTP API.
  # Ref: https://groups.google.com/g/spatialite-users/c/nyT4iAJbttY
  # Ref: https://www.gaia-gis.it/fossil/libspatialite/tktview/ac85f0fca35de00b9aaadb5078061791fc799d9c
  patch do
    url "https://salsa.debian.org/debian-gis-team/spatialite/-/raw/38481157178415322d78a3a45dab18f0c1d45daa/debian/patches/libxml2-nanohttp.patch"
    sha256 "477188c95b635e0abb97bc659ce9ba8883814f9c7d2466352491eabbe7f6a3f9"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

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
      --with-sysroot=#{HOMEBREW_PREFIX}
      --enable-geocallbacks
      --enable-rttopo=yes
    ]

    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Verify mod_spatialite extension can be loaded using Homebrew's SQLite
    pipe_output("#{Formula["sqlite"].opt_bin}/sqlite3",
      "SELECT load_extension('#{opt_lib}/mod_spatialite');")
  end
end
