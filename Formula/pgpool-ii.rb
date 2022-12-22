class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.4.1.tar.gz"
  sha256 "4b379bbba8e178128a1cee4a5bd1ae116dedb3da6121b728c18f0f54c881f328"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "768c019889fdef3d35bdb51da1ec7bb28c7998035ba6df27b8f5fea290f9726c"
    sha256 arm64_monterey: "0412eefd636ac737ae0ec107b3a75076d514a92170c609c338e0c333ee39d1ed"
    sha256 arm64_big_sur:  "2d7b43d5b3cfe53ef4b2fbe9e879d9e0cae4aeb0fae0b0aad59986feb6951d81"
    sha256 ventura:        "4b05c2c6b26ae6a14dd88efc9b6befe75368120f34aee0622f5fb5244acd1f2f"
    sha256 monterey:       "0dac5480136758bc717b26668b930d7eb574276d59ca6a353677691519431ce9"
    sha256 big_sur:        "1189290cdf17f4ed87b09cad3078d6bd063725786ffdd5efd44462a30028951b"
    sha256 x86_64_linux:   "cf56ecf608daba8251534445599a92a130b06a9f4b2257d3d578f84dcb48617d"
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
