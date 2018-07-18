class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.7.4.tar.gz"
  sha256 "2312f0fb16baa4efc3b42c6f814c399c6856ddd60abc656cf0f82ed33dca9a6b"

  bottle do
    sha256 "47dd6bdd5eff9d9705f8ebc27967baa8bb0caf11bdda5c62cef67406b1e07daf" => :high_sierra
    sha256 "fbd2039a714413cc0678cd99135e9cfc6cb0d247c9c6b7b91579e92a8f47bc87" => :sierra
    sha256 "05535a283da10c44b7718b357b868ec64229ac6eade3c62d01582b7d4964072f" => :el_capitan
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
