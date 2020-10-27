class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.1.4.tar.gz"
  sha256 "b793d516e21653e08b821af4816f69db262d876d9876372e9aa4f4539e1b6bb5"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "98fb748b5e21ef39138e3db09336cc8848d4149a478d29cd649743829174d374" => :catalina
    sha256 "9b091f6ee580595ed7344fa1179d1cde7e192000e62c70410082ad45b80dcd53" => :mojave
    sha256 "e50db96eddf72434629e5fd2e42ee7f262f74f694cbc0cd2f3e85b0f80790be6" => :high_sierra
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
