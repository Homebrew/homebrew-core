class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.6.4.tar.gz"
  sha256 "ef0d2e91a9a11d737c6476247219e679f718bec53550646189594ef9aefd298d"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "ef795af0913af3ecef71990761666306ca8f102cfc7051033491fba416516a8a"
    sha256               arm64_sequoia: "764becc67fdd664db20865f57017a2af5340f8d58b79381c3d2ab190f839ae1a"
    sha256               arm64_sonoma:  "b17cee9294bf4c8975d0c19eb5eaf6f6f28c4152e1ade6e56ad5cd137a75e239"
    sha256 cellar: :any, sonoma:        "33cf9a6031105594cbf1e8edc11be411e0b8e17cd9ec33abf10d87ceaf5b31af"
    sha256               arm64_linux:   "5c32eb3ec88752f3b85ccb342f2dedf34b45f858164176db3afe7ced79a08647"
    sha256               x86_64_linux:  "43b17e18cf2e5f1d6f5cb3b6feeed822663dec54d23c405d2e9c0d1c7764b12a"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--with-memcached=#{Formula["libmemcached"].opt_include}",
                          *std_configure_args
    system "make", "install"

    # Install conf file with low enough memory limits for default `memqcache_method = 'shmem'`
    inreplace etc/"pgpool.conf.sample" do |s|
      s.gsub! "#pid_file_name = '/var/run/pgpool/pgpool.pid'", "pid_file_name = '#{var}/pgpool-ii/pgpool.pid'"
      s.gsub! "#logdir = '/tmp'", "logdir = '#{var}/log'"
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
