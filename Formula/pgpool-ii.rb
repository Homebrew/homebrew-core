class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.3.2.tar.gz"
  sha256 "5715f562635f41fc6b62e241cd753109a3e2014ccfb62352063115310d034f0a"
  revision 1

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "779d9e95afd8fc07db1034793b30b131ccba1d3688e0b50a8a2c25c8bc88c227"
    sha256 arm64_big_sur:  "ee3977af0bc20371e4932713049c82c429092b1627ca61a6e1c5f90d7e5e2395"
    sha256 monterey:       "62aa8b19ddc1e05c12d97b6d36b42f7a9e089dcb81600942b00817f24823fd64"
    sha256 big_sur:        "e7acc7dc362c25c63684698159d8957dbde2fff765bf99c4f4736647a9d33307"
    sha256 catalina:       "5be2b2d8e34e4af30435a1e63034cba062424976a84bb7160748c1e167217d05"
    sha256 x86_64_linux:   "158cdcee168905711ca913ba746050ffdbbe3a331a5d8fcc3b1ba0ba60a9ba77"
  end

  depends_on "postgresql"

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
