class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.4.4.tar.gz"
  sha256 "10bed66f8197c74dcb00a0e73f618066d5d5e0adc878865c2fcfa1c945e68f4f"
  # NTP license that excludes distributing "with fee"
  license :cannot_represent

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7ef99d9a9a7a5e6d689261c3e6775ac066228e4ed808acd2e140089e727ea85f"
    sha256 arm64_monterey: "5c1a35fcb786a6c6642fd1e6eb6f82b885fcd8372e048a224403875f648b240d"
    sha256 arm64_big_sur:  "c637136b04faacc236f00e6dc5e26b046eddd1f11de50a5480517530455fdf5d"
    sha256 ventura:        "979124aef4621cdb480b2e828ec07387b1f7c63bdb9dc60a3880b03270ec0b9f"
    sha256 monterey:       "b3e9be633db629e3819b95e9080c5ffb1a85be92a6596fce6327cb31a0ae0969"
    sha256 big_sur:        "09afcf624639d670fdeeaeb14c4aeddb7e0d62518d2b7462e94afd89542b2101"
    sha256 x86_64_linux:   "67038ee8f2d59677772f6c5a0f40d08ff810e06ed87b8817401414aa3bebb1e6"
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
