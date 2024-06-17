class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.5.2.tar.gz"
  sha256 "480ac23f01cd7d6c856b29386bf17a848712fb4b4057d4c8abd5c8bf819bdf06"
  # NTP license that excludes distributing "with fee"
  license :cannot_represent

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b7dab26385d7053ad6894bb34a08f2e39bfe7046264e0578d14987728c25136c"
    sha256 arm64_ventura:  "9e506744ac1641ec68b7c7dcc4e33fe23446e937fab3ea1d54a6794c6e7c565c"
    sha256 arm64_monterey: "ffc4524a151bf1a33c420f7af01604d519a34a09fecf63e3d9f0fa9a50cec965"
    sha256 sonoma:         "9aacee51910b1bd2a8d86b5225feaad486e89f50ecfdc0c180a47bf3487d3d99"
    sha256 ventura:        "4ae4ea2566399c1287554908c1c692967865f2104c0f7df85b0abcdec1a3d967"
    sha256 monterey:       "df76fa2946ff78c4db0fce6620163cd6d7f72cb287aa7eef8cd10c626644d4e0"
    sha256 x86_64_linux:   "6187634082c2e7bf18f579ce128a468ac74deca22fd2e0c4872b99ce85c5abe3"
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
