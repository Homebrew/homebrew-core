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
    sha256               arm64_tahoe:   "d4e452ae158f90ef4228717bbe6c9b9d3678dfe797abdda1e6dfd40faa1d0dd8"
    sha256               arm64_sequoia: "3062a0e20358f8e941be43ebdafc4be5b332258494933a7ba1d5d35d1157c06e"
    sha256               arm64_sonoma:  "263936a2aa00c0996b06cadc34a28cf70cd27389f69de3f10ab79d0cfe19a052"
    sha256               arm64_ventura: "b0c66cc882f57bec2e56dcce1fb3487680b9e183e09bdcb6f96ec97f01e0f947"
    sha256 cellar: :any, sonoma:        "82fcc1e906022b1a61ce212c0cb68350497c503a05be8405b12f10ec67e753bf"
    sha256 cellar: :any, ventura:       "6ba91098cf31925d19ab65de6c9870428ef5422cd64e2415d5b30ef1ec10f4d3"
    sha256               arm64_linux:   "95096edfd72538ac1b6c4e4226bd7e9ad7b7278ca138078c533538a8207869ba"
    sha256               x86_64_linux:  "8959b7c3cb8529ef2f429b98097f070e716bd80af8e0a5e71720d8bc06634487"
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
