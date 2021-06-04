class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.2.3.tar.gz"
  sha256 "1cd3a9100aab6711050b291e94e4805287182054ce7811a697bc05723150d6cc"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "2ce3327f92627e01c2d752ef3ba9eca9e585799a9f61d83698c130fce033d32a"
    sha256 big_sur:       "f32afd6fc0f3c89085a10e84f8bb228bbfb73c915090c2e177bc98b0e64f1e54"
    sha256 catalina:      "2fae0f2d0ed2d7fa2557737b3d12ff24aaaabc478f0d6b97977c75b8abb04165"
    sha256 mojave:        "72ba77fd27a7bc1f16b0bb348874b7c8698f64f51e6cea2292da06d6fc328d16"
  end

  depends_on "postgresql"

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
