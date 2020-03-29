class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.1.1.tar.gz"
  sha256 "b6e334984aeed36e1a882266e65963dd0f5145d19bc0b30019c0b566dce33b61"

  bottle do
    sha256 "f4c7b6a5113ab08954b13adbd5c3a0ce133432e3d1100826b72c61334a52d8eb" => :catalina
    sha256 "5c2cdb579dddfb07dd9a01fe067e99c453aea5d38e0288d78227af549a4e20eb" => :mojave
    sha256 "2caee2fcf473e8e0d3a3f4db4df9be993971c47ecdf4ccd631d21b96ab3e8be4" => :high_sierra
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
