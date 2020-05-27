class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.1.2.tar.gz"
  sha256 "d13b587c1268fadb687adc1a2255cf573f9eaea511a9661955ceb7deb6821811"

  bottle do
    sha256 "5f64f049dd3f0b8211dfda69c4099035e3dd5192907507329c5dc03b1deed3ac" => :catalina
    sha256 "a7415fcbf87a371ceb7545b24946e198982aa8af29583506ff6ffaeb0730c92b" => :mojave
    sha256 "d3a77fd114c9820e94ca5a16bfc450dffdc1960baaeeba7435eb03390d97f77b" => :high_sierra
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
