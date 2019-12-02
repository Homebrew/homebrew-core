class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.1.0.tar.gz"
  sha256 "a2515d3d046afda0612b34c2aeca14a2071020dafb1f32e745b4a3054c0018df"

  bottle do
    sha256 "f0345ba016affb5d1d718d238102b3a4ec1822e7a4ffcb8d209e2958caf6211d" => :catalina
    sha256 "f0bd5676fef620c8563f68052feabce36efc381b2bff270c2de73feb0e501207" => :mojave
    sha256 "c26e2e70e201538703d28744101d714940ba6af7d0260e7ca4b8d181a16a96c9" => :high_sierra
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
