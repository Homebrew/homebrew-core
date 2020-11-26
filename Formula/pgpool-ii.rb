class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.2.0.tar.gz"
  sha256 "7220e8f5c0ec14a2d745f4b99f44d97caa51df888c63984580361378eee0cdb4"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "b7d1804401e059f37975d2b3d6187bcc1b744163cfdbaefaf88dda5f1207f2e2" => :big_sur
    sha256 "e963963b5e7b02157bb7bee2723950cb1d9e44408a0e44c70e6d2775d5af9e92" => :catalina
    sha256 "c96f6c768856da44efdc3a1f7f310d9cbd9b654b277bdf9095ec5038ff0c3ef4" => :mojave
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
