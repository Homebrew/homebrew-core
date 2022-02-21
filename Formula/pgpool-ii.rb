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
    sha256 arm64_monterey: "3c5917083bf0def3d3d21b53634a7bdd79c41d0b91ba016817ba229730de903f"
    sha256 arm64_big_sur:  "5c3800b2dff1f8dd85446a0fe1f14758acb04f4ffa56adb7f99e089384efc955"
    sha256 monterey:       "baaae18ee88dc96cfa0d05b0588a44dc00ad95bfb4e2094aaa88045e18fc8211"
    sha256 big_sur:        "f383d0419b277ba1c6708cec92d0ea777003b84c1b4d450c23aa327d844e32e8"
    sha256 catalina:       "caaf22c3c01c3ed2e8e5598d349b2171f5554f788633dfea4443a54b3de6957d"
    sha256 x86_64_linux:   "b752a7a0c9a3a414cf1f54d8c96e43bf1f4b16f20dc917de44a130abe0e6e71a"
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
