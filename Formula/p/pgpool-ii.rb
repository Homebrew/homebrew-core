class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.5.4.tar.gz"
  sha256 "d1392e74ce2807f8ae628872cb1ab7914249921180dc99df40a1d602647a10fd"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "c5cadac99e760730866866a92b9876016432aeb6c3daca16852054fd3bf8a948"
    sha256 arm64_sonoma:   "e94257f4d550e65a06e4eeeda0d058fc5a13c0af6810d459cb2e258d8889c95a"
    sha256 arm64_ventura:  "e6c6ef25b196c05f2b838206e52e55667f8e46a274dd8e957bacb970435e6613"
    sha256 arm64_monterey: "9eccb085af5582d16e3263973604fe30e48d94ecd440aab8013235016a8aae86"
    sha256 sonoma:         "81c69f26dbdb46ab89c873fc6afc99c37ca847ced2559e514ece31a1f1aa01f8"
    sha256 ventura:        "515495e829260efcf080d89548fdd3efda95f92ee6244edc0dcbd54353314646"
    sha256 monterey:       "9ec67ed16c9a3b036c86bd33eddd1d15ee2cdbe8444732325acd562f981981d1"
    sha256 x86_64_linux:   "5e795abe5b903b131e37e956395f5a9af9a6e8ab5d8cb584210c92d7cb28eba2"
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
