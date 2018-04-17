class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.7.3.tar.gz"
  sha256 "a58fce7cb9b3198d1dc18b40e47066d30049e8059e8ce67a568d5b1e0b6b91e7"

  bottle do
    sha256 "bc423203bfa50acfc5bf818514fe08cd715cdc1bba1f5bbef634d8eb3a5452b6" => :high_sierra
    sha256 "b3089005f4794acf571590f7db65476dae7ac0c7c39ce8371ed1fb0b6d37ed52" => :sierra
    sha256 "600623571d172e9d980500945233e2af293aeea8080e4fce5844932ab37640e6" => :el_capitan
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
