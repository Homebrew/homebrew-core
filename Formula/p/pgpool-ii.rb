class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.6.3.tar.gz"
  sha256 "46688668b2ace67d8161a320256252d98698bc7d9788cc6727269d5720299f2c"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "a06a7dced7cb84105dbf2eb72ffb44e9fbab82609a800ba8f7aa157e9e96c713"
    sha256               arm64_sequoia: "6287616f0bfad76a637ee26b2e9adc3f98648a30596bcc2fbc750128a311836e"
    sha256               arm64_sonoma:  "118e68699416b5cd58ead4a47b0e1f22d89cc0983cf19a4f63b0fdad991f6fea"
    sha256 cellar: :any, sonoma:        "9961d0426b00e5271709020b6e4a54c3ccd16cd20f8869043477ce27314a9984"
    sha256               arm64_linux:   "ce6b27d65ebe473cff8285ce3e85eba0c16c6b2a087a9e0a7adf190530350ba2"
    sha256               x86_64_linux:  "da527e1c84411626b9532e3fbdf708436efa229527081e864d3be70d08c8437a"
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
