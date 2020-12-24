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
    sha256 "79fe17f3a82a968e823f89744aa5983f8744981b56588bc1ee0359e0c8f44511" => :big_sur
    sha256 "c5aede9bb5f4e668d154ae3cbf0f2b1412494a52180289658069493b9a140381" => :catalina
    sha256 "db10d11faa36b3236dbb5c6b3031032cdc3b12e70eed802fc4f6b0628ada7378" => :mojave
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
