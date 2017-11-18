class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.6.7.tar.gz"
  sha256 "09cfe2cb36b9171d4a987a8b100e298e46d6a369c1b61d9e1a47d442ce16e249"

  bottle do
    sha256 "d3d150df92b7ff7d7956ac0f351a00284921c41e26d93ae14fe6d841b357b449" => :high_sierra
    sha256 "87b327d37b58c8ac1c65351ee16b8a541525481d3d02701c2cc12eb6caeb100b" => :sierra
    sha256 "24fddb94c6b055d242039bdeb9c3b36f8d3afd602fb2f7b41f0654d72edb7a39" => :el_capitan
    sha256 "b4ef5cc69fdca07dd243a5654a2192a26039591bcb3a11a87bac559aa23dedfb" => :yosemite
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
