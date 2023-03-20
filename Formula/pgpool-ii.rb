class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.4.2.tar.gz"
  sha256 "3e6c788e70f0672c7b38c88a6ca76f31f3786b125689980cc063ab752ca58234"
  # NTP license that excludes distributing "with fee"
  license :cannot_represent

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d2105b1d4311344b47ba7748280a58e01a1322af3430ddf1181ecf5f54210e37"
    sha256 arm64_monterey: "86a877722546e1b6f26378ffdee7df6fde71be30b0e54e6f0ea483d94bc86ed0"
    sha256 arm64_big_sur:  "6cd7a00c0012d02cf8a5e83000d860d26744bab524b3309401475347368c84b5"
    sha256 ventura:        "89e24abbc05e6cd7b9c6d6fa453b4ccd1a5e7afe21190bb514ee11fb3ae5b006"
    sha256 monterey:       "709d695fad63ddac0b5596be9cc34d1d23d5466c85b2f1905cba0c44a2496520"
    sha256 big_sur:        "7730d86e148fa8b9dd065e6fecf19dbf8546dbb009794b82e77aaf84cbc3193f"
    sha256 x86_64_linux:   "b9ec13c9137e6446ae5e2fcabdee042fd9c2e37e47126d6b7672040369255580"
  end

  depends_on "libpq"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
