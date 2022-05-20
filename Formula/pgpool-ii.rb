class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.3.2.tar.gz"
  sha256 "5715f562635f41fc6b62e241cd753109a3e2014ccfb62352063115310d034f0a"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ef9e1d85dd0408f231620471f8973e9938bca70703858bdd6ce377e9dc972e04"
    sha256 arm64_big_sur:  "428cfb6fa6ca6907f8bd8bc8e2fd0033190e3b41b75044db00df22c546f45ab7"
    sha256 monterey:       "f2990632c2c5d29b42a984ffee627658416e8bb63f558921edf29f20b85ff4f5"
    sha256 big_sur:        "1e1226f8866f6452abe59dc763d5030a24fa825146f364daeb30f3fd174e8bfd"
    sha256 catalina:       "01bfd000c01f4a917e5689e348c9b1d7bb0bd17aecb2db0ae2c7155bc5672cbc"
    sha256 x86_64_linux:   "9b1443b0444aca2330656f3d0c557249e537b551626a9c5124fbd8c11cb9f54f"
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
