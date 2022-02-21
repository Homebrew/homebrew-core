class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.3.1.tar.gz"
  sha256 "b4416bf4507882847a0e72ebe80209a7bf3b104aef03837d528502d84203507a"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "074b03b6c0e8d7b84f8e903ed560e2ce3cfe11c3b5e13876033e6b2135010987"
    sha256 arm64_big_sur:  "c7b7bb9a3f1e2728cde2033e1307a3bfb1765ec3ebb1a67ea76f69822755b0f5"
    sha256 monterey:       "f0e8e796d169bd27b1b8af149723d96caded0a85c219886a757dea79bb88685a"
    sha256 big_sur:        "b17e928829e63bcfbdb05e6907d871444fd8298280fba54ea7431f790c22de12"
    sha256 catalina:       "90de27f6ea8a5e8d5a3f71f2751571ff9b5de72cd45f0ebb9a9207f8cc8f90ea"
    sha256 x86_64_linux:   "4f05dcf54d2066c9bd0f3b706e6b4e08c701ff25d71c0c0be62f86aa902c828c"
  end

  depends_on "postgresql"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

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
