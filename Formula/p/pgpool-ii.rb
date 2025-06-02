class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.6.2.tar.gz"
  sha256 "116c9ed475efd0265329c90273053a1fa6a18ee68d5c54ed46797cd0e001f648"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "0254ea49d14ca0a41eb2d78822c0c936fd6839511a042c4032506343bdf5f2fe"
    sha256 arm64_sonoma:  "708a947e7580582b32a71d7d4b111b7ae4586e36819e4eac34a8d454cfd403f3"
    sha256 arm64_ventura: "49b6903c9318613a6ba36dfd0c1294c65b0c5be34a8bd961fcca6d21d29938de"
    sha256 sonoma:        "2c7cb7f2cf0b8d2574801a485154bbd655b8390f9cffc1d391ea08e7ad5378c4"
    sha256 ventura:       "4b9e23c9f9adb9815fffd2191487edf8c94fbb9ba54c24d62d8b164e7e228b8b"
    sha256 arm64_linux:   "7f0e13d03850e2b3e9fa2bd4d0205f5473748b71e40b875fd75026673400cbb7"
    sha256 x86_64_linux:  "d0573eea96263ecdbf8a92a8a55369ed0ceec72207eb98da83deb72cdd4a8544"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
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
