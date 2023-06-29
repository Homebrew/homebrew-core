class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.4.3.tar.gz"
  sha256 "46745aa98f454e097cecb4dacf536f89c37ed3ec41f32f0a846934229d0eb733"
  # NTP license that excludes distributing "with fee"
  license :cannot_represent

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7ecca17847fff3e7bf251286ff0ad84af40a1b05b602a0e4013589412761f716"
    sha256 arm64_monterey: "6fb793d67ffcd9ffff510da1914323826b90bbb9b69b713648a415d6b7c66c1f"
    sha256 arm64_big_sur:  "3f52e2954fcc4b66dda006cfa9e13c0a55018710b69a403cc9ac1aaaad285c70"
    sha256 ventura:        "c15bf808ece779126cd6b08b6108e585daee4eb61fb5e53ac6d963c911bdbab2"
    sha256 monterey:       "508da5f337474e5dd92e29096387959533f95acdc33ba736bf5a34801bf8bd4c"
    sha256 big_sur:        "c1f722260821a3573e282fcc4c32b9eb818f7f76254e5ffa02ab76991739a559"
    sha256 x86_64_linux:   "a4c554eaa0e0a91076e188a2fc7080d3f535eab1739b07234010b27de396a915"
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
