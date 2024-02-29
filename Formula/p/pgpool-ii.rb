class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.5.1.tar.gz"
  sha256 "8e14b0558a15dae8767c8e1acee3f2f6c7c08ebfffda66a359367eaaa56c3936"
  # NTP license that excludes distributing "with fee"
  license :cannot_represent

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ec4d38c4b5c73bc5cbcd3c2355e20cb1c6ce302392585bdcebdafb3aef15b917"
    sha256 arm64_ventura:  "807ec55e9d36041dc0c190ca21d3d10fd115355fb10f649f4864c4ef8aa979ee"
    sha256 arm64_monterey: "38480a1464a8da32afda555d67b8d1f65df6493196b012681e9d12a20b69041d"
    sha256 sonoma:         "b3aca47abf17eab1e042f314d209742bdddb148934a3d37ee5cd3578d797d1bf"
    sha256 ventura:        "616694d55e745fbb55bdd46a6d7d01e5db47ad2382eb7839cb181a2ceda33033"
    sha256 monterey:       "c4087418b227e67985b445b7329d3cc3c4bdea7104b6718369c67d9b9f1468e0"
    sha256 x86_64_linux:   "0ecc3f571a533b689a749f83de5fb813e23a909ba5efdb595eb2f6d9aa796785"
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
