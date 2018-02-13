class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.7.2.tar.gz"
  sha256 "f3f2825ccfdaa52f5e3d863bd43f1dc2ca37523a5f01b633db76596e73613ba4"

  bottle do
    sha256 "bdac155aca16d307fa9e8e8362026e3ad76a1bfd1426f7f7586ed97b1d8385c6" => :high_sierra
    sha256 "97293af1908297a87e21dec870c405643af380fafe740ae85cc4750126afbe1b" => :sierra
    sha256 "97579074ae09ec6954191714896d864074aa9a9609fc9c1e0726fe04263901b7" => :el_capitan
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
