class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.7.1.tar.gz"
  sha256 "9ee55642dd4450191a6452a0aa6de6d1c5f717ac64cbca0b9367b7c5808ae142"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "898916cee76fefbf45347cc364f3fce32a05b0071740a4ab491ce779803ed179"
    sha256               arm64_sequoia: "5420df37f58cfaf70852073307b6c901fa3e84e1b17af3dd76a33158391000fe"
    sha256               arm64_sonoma:  "4d558e1eb95a2af64ff322fa9727b720d64d576ed3490d9f39e34c816f9e5c05"
    sha256 cellar: :any, sonoma:        "24476956742b91a87968d2642b5b6b7c4b876afc00dc33eed699538a154ba08c"
    sha256               arm64_linux:   "a0c94479e17ef08a249523d3218ae1bdb5973832309743f88879a854594fd07c"
    sha256               x86_64_linux:  "a3856790fbe145805893209d93eff5538d25a3408e85c2683239df9d8c7a471b"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  def install
    # Workaround for use of `strchrnul`, which is not available on macOS
    inreplace "src/utils/pool_process_reporting.c",
              "*(strchrnul(status[i].value, '\\n')) = '\\0';",
              "char *p = strchr(status[i].value, '\\n');\nif (p) *p = '\\\\0';"

    system "./configure", "--sysconfdir=#{etc}",
                          "--with-memcached=#{Formula["libmemcached"].opt_include}",
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
