class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.5.5.tar.gz"
  sha256 "95ffeeaeb6b0cebea8034e30fc1933fec7384b227ad511305eaccc5d090ff998"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "dc7c177f6d0a4b7a08c77fdacc685df6d34f1cfaab27dbf13b23532d039dedb0"
    sha256 arm64_sonoma:  "a0537a08d697ecc06cea322da0241f078e54c594f243ccf1d0b2da8da7801ee7"
    sha256 arm64_ventura: "c4b705b59345da8d0f9301c598b46b97f36e1b9aef37d625eaef9a4b59f63d57"
    sha256 sonoma:        "a1b0f3b0ad24a12189df29521300a5fb3253e42489d109e4a37b5f6a7504cebd"
    sha256 ventura:       "44478a3903015bc92feab8424854894f7916d74b4d99703ad7263ffe56007eec"
    sha256 x86_64_linux:  "0f63a412c8dc49dcab047fed55e828f2e981aba59ab3ff049e6f46a65cbb05e9"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--with-memcached=#{Formula["libmemcached"].opt_include}"
    system "make", "install"

    # Install conf file with low enough memory limits for default `memqcache_method = 'shmem'`
    inreplace etc/"pgpool.conf.sample" do |s|
      s.gsub! "#pid_file_name = '/var/run/pgpool/pgpool.pid'", "pid_file_name = '#{var}/pgpool-ii/pgpool.pid'"
      s.gsub! "#logdir = '/tmp'", "logdir = '#{var}/log'"
      s.gsub! "#memqcache_total_size = 64MB", "memqcache_total_size = 1MB"
      s.gsub! "#memqcache_max_num_cache = 1000000", "memqcache_max_num_cache = 1000"
    end
    etc.install etc/"pgpool.conf.sample" => "pgpool.conf"
  end

  def post_install
    (var/"log").mkpath
    (var/"pgpool-ii").mkpath
  end

  service do
    run [opt_bin/"pgpool", "-nf", etc/"pgpool.conf"]
    keep_alive true
    log_path var/"log/pgpool-ii.log"
    error_log_path var/"log/pgpool-ii.log"
  end

  test do
    cp etc/"pgpool.conf", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
