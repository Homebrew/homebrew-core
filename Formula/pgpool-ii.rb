class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-3.7.12.tar.gz"
  sha256 "08656fb0a7f5044eacf4aab76a1fcca7812dd6334d965227c5ce0cbdb45e4151"

  bottle do
    sha256 "0b7d1c439f979d4301ac989192cc3f45117860c82821ea7897d0e9489f3feee0" => :mojave
    sha256 "ef331729edaa2b021f3c1aa7f681aef91afeed1c953d07a0193d50e33c8def03" => :high_sierra
    sha256 "a6971651f3305e14bd675eca89652722445d49e83dff68d5ebfdf7792a4171c9" => :sierra
    sha256 "e277a0b2d1f240f4ba4047b48f03a852ea9c4b6b9dcc33b1b149938d0c0c7e20" => :el_capitan
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
