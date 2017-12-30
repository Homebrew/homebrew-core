class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.7.0.tar.gz"
  sha256 "52d409493ff5996477d58d01ce376cecb3335869a8c6b84063604d676eeefa88"
  revision 1

  bottle do
    sha256 "daafdd8dcfafd7d0643c05d601c91196b6f741d92ca7b57428142b5a63087ce5" => :high_sierra
    sha256 "32a09816dd2efad99cfcd4b7ff769181329a2eb3649e0a969be117e68ff11c38" => :sierra
    sha256 "a95ccb1058918a3e58c1cda1cdfb9cd4a69f49b400c5b8960f4673d372e006bc" => :el_capitan
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
