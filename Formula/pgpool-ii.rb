class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.7.0.tar.gz"
  sha256 "52d409493ff5996477d58d01ce376cecb3335869a8c6b84063604d676eeefa88"

  bottle do
    sha256 "974f7ce2a82f08b562e43550702fcf740cf78cfc07e8da10c995d3f7533dd26c" => :high_sierra
    sha256 "da8d5bd22db059cecb074d870b8cc2c06001c48fdd2f1b5189bc7bf6264204df" => :sierra
    sha256 "adfac17fccef42df3aacbd412fa569784df150261c0c2af8347725e5b6572b93" => :el_capitan
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
