class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.2.4.tar.gz"
  sha256 "153902289bcedb0661c8029b20a17c19eaf705d6380e1e2dc5567560d585d6e1"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "b6e774e1c265b724a69a8e26f65aefa5892e5e6093fb64534cc792b5ce6f52d6"
    sha256 big_sur:       "0dfab87e936a627382e26f692d6e6ffabbc90918470b951f65ce175ce932c583"
    sha256 catalina:      "261d76647ce7ff884e69470e13065d67a9bbd28486bfb7a3171286c5dcea8379"
    sha256 mojave:        "d23935b493e82da155b06373a2ed7a47a43303ea7bb186fb27a3b20af63cc827"
    sha256 x86_64_linux:  "430f7d5309d2163b186b9ab83b864af899675620f6565032c63152ea05d4a26a"
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
