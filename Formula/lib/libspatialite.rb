class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 3

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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec71d022fb73c458f7cffae0653b47966afedfd983505dc3f258de7cee10ae69"
    sha256 cellar: :any,                 arm64_sequoia: "f8fce6ef602c6ba94ba50021c98ef28d4f229e2a1b68c67af847c72cc3f86340"
    sha256 cellar: :any,                 arm64_sonoma:  "e6cdb74bf39ad03b1cbee89f33d2e0c1995e996c54b15ba616cf45035ee0a38e"
    sha256 cellar: :any,                 sonoma:        "1ba1a71a2e5f482de9dea30d398ef7848313d2012dce11233c6d66b20bd9df40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a76a81771f5568851ce32fbf406a060b4d7f9946f7c8e11ce99c52439bc076b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a454cd563efc53e1636abd085bea6cbba2b5dd7c95727cb496ea8881966deb"
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
  uses_from_macos "zlib"

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
