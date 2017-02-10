class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.3.tar.gz"
  sha256 "b030d1a0dfb919dabb90987f429b03a67b22ecdbeb0ec1bd969ebebe690006e4"
  revision 2

  bottle do
    sha256 "1aa0eb2008f86f8f37a96d73e56250b7f8eea519c17c8576b496ddf101028e73" => :sierra
    sha256 "7fe44722000c597a5de7416b81f20239987bdd68b750d2d8ed8b2f577d7f0276" => :el_capitan
    sha256 "356c71c1dbdd2dd0dd97dfafc5e7f610316c33e0e386dd9383e5e504f71930a2" => :yosemite
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
