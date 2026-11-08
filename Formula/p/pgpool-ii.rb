class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/source/pgpool-II-4.7.3.tar.gz"
  sha256 "4bf9df3e13feb8e64bee486b4ea54c9076296c2d9406165b0b68d32086fce250"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/download/source/"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "cb71b494c300df3e12cc09c5dd3dacc261758ec35692981c8a21d69a2c981d5e"
    sha256 arm64_tahoe:       "9d74be8e67d2a9b5fe4b9cb0d3582dada5118aeaaf5cb8ecdf579b32d29f43c4"
    sha256 arm64_sequoia:     "0cb3474abf61352c568ab77dae2f380425804ed466d2df25653aceb5c09bcae4"
    sha256 arm64_linux:       "e54782b68ad3ed9bb28472336682172701108495b7cbd01575bd45bd04af494e"
    sha256 x86_64_linux:      "a16ac9affa056007d0df41a0f9bca0892f10a568a2e40cf1e95dec9c24eabe96"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  deny_network_access!

  def install
    if OS.mac?
      # Work around old libtool's macOS 11+ version detection:
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97865
      inreplace "configure", "$wl-flat_namespace $wl-undefined ${wl}suppress",
                "$wl-undefined ${wl}dynamic_lookup"
    end

    # Workaround for use of `strchrnul`, which is not available on macOS
    inreplace "src/utils/pool_process_reporting.c",
              "*(strchrnul(status[i].value, '\\n')) = '\\0';",
              "char *p = strchr(status[i].value, '\\n');\nif (p) *p = '\\\\0';"

    system "./configure", "--sysconfdir=#{etc}",
                          "--with-memcached=#{formula_opt_include("libmemcached")}",
                          *std_configure_args
    system "make", "install"

    # Install conf file with low enough memory limits for default `memqcache_method = 'shmem'`
    inreplace etc/"pgpool.conf.sample" do |s|
      s.gsub! "#pid_file_name = '/var/run/pgpool/pgpool.pid'", "pid_file_name = '#{var}/pgpool-ii/pgpool.pid'"
      s.gsub! "#log_directory = '/tmp/pgpool_logs'", "logdir = '#{var}/pgpool_logs'"
      s.gsub! "#memqcache_total_size = 64MB", "memqcache_total_size = 1MB"
      s.gsub! "#memqcache_max_num_cache = 1000000", "memqcache_max_num_cache = 1000"
    end
    etc.install etc/"pgpool.conf.sample" => "pgpool.conf"

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
