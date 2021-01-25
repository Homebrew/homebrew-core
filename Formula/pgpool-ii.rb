class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.2.1.tar.gz"
  sha256 "98938af9fccc37bcea76e6422e42ce003faedb1186cdc3b9940eb6ba948cdae1"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "0cf130171e6dee4a3c0cd5034a6d32031a137ea51c1f054047974b6a97b474cf" => :big_sur
    sha256 "0d35b158d2d40bf8ee53db5774749ed7254874ce6f56c0eb0ac9a12510e2813b" => :arm64_big_sur
    sha256 "61f0433e8836ce6fa178158889c0026af1220f169101f766419d3a470ef72f49" => :catalina
    sha256 "ee328e472570d92320f144ba86530d9a5b8fa81e00813d2404aabfe7fc40e0ad" => :mojave
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
