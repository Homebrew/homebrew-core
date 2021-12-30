class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.3.0.tar.gz"
  sha256 "1650cb7db960c83386dade17372f2306c427d05f42e2a94559abc183576dd213"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f85901657a0ab4d1dfcc1a414ab6572a2d5bdb4cfdd77c9b0b8f38ed56f7dead"
    sha256 arm64_big_sur:  "1275c3dab70fe3ffac1964b3b86116dedc74893f757813218b2143b27fed9be5"
    sha256 monterey:       "6051114fa57c099832a7dcc5559e28bd6cd659231af93961e82048163cd6be73"
    sha256 big_sur:        "a917a8b4169373361cc165666328cf55dcd7cff13cd4a6912ffe30222a0f26f2"
    sha256 catalina:       "45b68d91937ad3777c8c80a02bdc7bf1518fca392f5ef1ed04bd901bbac85fba"
    sha256 x86_64_linux:   "2adc774725168cc98359148b3ffa2f2bd264d1cb6d6d6fb79713419a130a9b59"
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
