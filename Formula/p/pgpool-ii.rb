class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/source/pgpool-II-4.7.2.tar.gz"
  sha256 "e72b9d0ff3620f7da7e33a58dda44b77919d056752dc9bd86b2985c4988d1938"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/download/source/"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "3806b34a57e6d14816d509815a5d20677cbaa384ee2a1b59882400bafa9cb15e"
    sha256               arm64_sequoia: "8d2ccc431f16cf61383927700db7093b5daf1716196fc29d38c9a89d3afd9b79"
    sha256               arm64_sonoma:  "8d84be999d0621382adcfcc1542e052f3b5dde0745fd6ecda5776bc072be5efb"
    sha256 cellar: :any, sonoma:        "3dc9d2b61e2665bb17261337f9604832dab5fec058e656db37c5c99f4090fc2f"
    sha256               arm64_linux:   "14a5c29f49ff4d7a1f6df15503efcbe8653730735c7527114301018e9a728750"
    sha256               x86_64_linux:  "16b632529ebf79e4bcc79ba949a2474e872b5285103238168ad0849c4f5c9c3b"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

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
