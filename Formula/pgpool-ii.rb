class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.1.3.tar.gz"
  sha256 "9749f3a4ca7d89376bc41932f4a267e0ca8d73db6757b16d92d8fed947734fb7"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "acdc49a0a74c10dbbc4453648eddee60d14adef61bd263801e37343720c5d22e" => :catalina
    sha256 "978b0b467d99e69292fc6f724ea2991256abef98584b2f4a9027c60c8e13e82b" => :mojave
    sha256 "095c16da92eb72e6da9e873c1f415b0e5b3f828c558f0f0b9ceb230ff367f83c" => :high_sierra
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
