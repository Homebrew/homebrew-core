class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.3.2.tar.gz"
  sha256 "5715f562635f41fc6b62e241cd753109a3e2014ccfb62352063115310d034f0a"
  revision 2

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c121b5c15a2475194f09428b32f54e7f9856eb75ef63e1199f6f2bb07a64990b"
    sha256 arm64_big_sur:  "cc2ba06e76c65440794acac0b48913ad83524991b0d2c133014b7773a3d66e78"
    sha256 monterey:       "f1f2722de65649f3eaee586c5acd82dc29f8cfe98efdee21cf38a9cb154efcbe"
    sha256 big_sur:        "94c3ec3b2ee0567ae4b33e011eb386187680d54c405837f3aa8165626633545c"
    sha256 catalina:       "0e2a318223b31392b285cbf26c4442ffcb9002d574c7196bcc53d2f26c61842f"
    sha256 x86_64_linux:   "9d67c42dc759312786765772a2409dc987b4892e9dfef6620fa4822041c98107"
  end

  depends_on "libpq"

  uses_from_macos "libxcrypt"

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
