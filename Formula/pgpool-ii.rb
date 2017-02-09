class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.3.tar.gz"
  sha256 "b030d1a0dfb919dabb90987f429b03a67b22ecdbeb0ec1bd969ebebe690006e4"
  revision 2

  bottle do
    sha256 "5fb685056312efeef58e27c203536b8d1b2e4b6f33aa4302baa90c5937c9064e" => :sierra
    sha256 "814632a68081d80fe33bb217d661bf88336f324697910cd709cda67a1f7be04a" => :el_capitan
    sha256 "678de12bb8c5669349dfe808ca3e08bfd5ed490fe1e25bf1057a8936fa6d883b" => :yosemite
  end

  depends_on :postgresql

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
