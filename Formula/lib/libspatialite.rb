class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2

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
    sha256 cellar: :any,                 arm64_sequoia:  "cd162e7a36e33bc982374bc2e8efced6d1669810852c6bef404967dc7507eefa"
    sha256 cellar: :any,                 arm64_sonoma:   "efd80614ae13d20ae2af905b7b6a673455d5d281e14e75e6511d1d4a1fdeda8d"
    sha256 cellar: :any,                 arm64_ventura:  "1a05eb0afc04b80535b62c3f6c602ed5ef6f7eaed37cf7bc940bf4539dab1753"
    sha256 cellar: :any,                 arm64_monterey: "2222ce79b7ac80c9d858390e201da7a3bae3fb432e363b358c943171cfe0294b"
    sha256 cellar: :any,                 sonoma:         "1f29fd1ce9216f960a3e22279b67cd0411ca3694160f6c5c0c769524dfa57567"
    sha256 cellar: :any,                 ventura:        "a45dd6acc0e93aa02176b73e0ff7ed57ac6c020e6a72538d16cbdd67c19a4012"
    sha256 cellar: :any,                 monterey:       "1bff63a0b2139edfa2d2df74870f98d6dba930d840973b6b523c1405e33c0279"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d86a5e1a777cceebc9eb059098c75d53d2fc0597c6b0e09799c9a66fc9ff4f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5fbfff96039dfc137d483a59d19c45d97c57c461570073f7005c602edf8f356"
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
