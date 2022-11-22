class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.3.3.tar.gz"
  sha256 "6c73434baee581386a9555fe59628bf467820f7d5bdbe3341768399a0382c979"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f859b822c4e63812880a2c1a098095bd3b7359cbc12b8fe150f1c7e3fe561b60"
    sha256 arm64_monterey: "eedfa1554111d90bae8aeff5a14169b69823ef348672c4cfc554a03c6ffe6775"
    sha256 arm64_big_sur:  "6ba946c5d04acd2bd5101d9d3b882d58f4a4dbae5ba92f3f5d96c5bfec7821ca"
    sha256 ventura:        "d645c5c43f080dcf0ed0abd8802076a5de7963708c98839d6d5c0c7ff31ce1b7"
    sha256 monterey:       "82546227f35da4d840670417ac58917fb2d393b1ae8467d6281080d24fd28850"
    sha256 big_sur:        "361c2fa788bbf27fdeffa1e7b75b83f45c32a7b4651b6e4acd20f0939f4bcecd"
    sha256 catalina:       "d81047a9c76402e976246f7f3ccc48c0fd0943e9957a7b02ad1e78c16379d412"
    sha256 x86_64_linux:   "85f0be3bbb50f34930fc55f0dca98ed4f79cd25fcd7802fec31a4befb33591c9"
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
