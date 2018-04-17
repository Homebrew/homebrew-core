class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.7.3.tar.gz"
  sha256 "a58fce7cb9b3198d1dc18b40e47066d30049e8059e8ce67a568d5b1e0b6b91e7"

  bottle do
    sha256 "2a8a5e160246dde93f018fe5d70b51add4482870ecd994c2ab538a40e7c24b20" => :high_sierra
    sha256 "90b9e8b9219d5911b6ae69ebe9194c36776caf754494ff500dfbe00c6ce3ac2b" => :sierra
    sha256 "1c719e5332333b62e2919072adcd41a03be488a780fe6352cc43758bc139cb89" => :el_capitan
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
