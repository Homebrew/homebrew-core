class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/6.0.2.tar.gz"
  sha256 "319dcdaa17fc4672cdec5cd5a679187f691cd9aec8ce31c3012dc113d99b7d80"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d*[02468])$/i)
  end

  bottle do
    sha256                               arm64_ventura:  "b6b02f0a06ae69222c6a1d8ea6f10644fe48e5a5959682f2fd5001daee893090"
    sha256                               arm64_monterey: "7b3a81a85a5de33278c2c7a794179d65070724f0016199ad9c2313a3c28e7f00"
    sha256                               arm64_big_sur:  "d053cd46be124556306f0ec634f6e4b13d010feb765851c91cd8f790e2ef783c"
    sha256                               ventura:        "d706b4a020000cdd4be782b4859c1e1fb0d47c1f095be376cad885f2a6b50f14"
    sha256                               monterey:       "24a65de3824d44ca796c32ed9b301d741686261671f54dacac2bea2181625260"
    sha256                               big_sur:        "803164603e829b35e868d9704d5f6de323548cf26bf42a7f3d732c80b9d4b9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a1f12ea1bdfe44b4bd10fadc45d01bfa6477328ffd3ac33d3ca66b885c4910"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "libpq"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  conflicts_with "sphinx", because: "manticoresearch is a fork of sphinx"

  fails_with gcc: "5"

  def install
    # ENV["DIAGNOSTIC"] = "1"
    ENV["ICU_ROOT"] = Formula["icu4c"].opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl"].opt_prefix.to_s
    ENV["MYSQL_ROOT_DIR"] = Formula["mysql-client"].opt_prefix.to_s
    ENV["PostgreSQL_ROOT"] = Formula["libpq"].opt_prefix.to_s

    args = %W[
      -DDISTR_BUILD=homebrew
      -DWITH_ICU_FORCE_STATIC=OFF
      -D_LOCALSTATEDIR=#{var}
      -D_RUNSTATEDIR=#{var}/run
      -D_SYSCONFDIR=#{etc}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"run/manticore").mkpath
    (var/"log/manticore").mkpath
    (var/"manticore/data").mkpath

    # Fix old config path (actually it was always wrong and never worked; however let's check)
    mv etc/"manticore/manticore.conf", etc/"manticoresearch/manticore.conf" if (etc/"manticore/manticore.conf").exist?
  end

  service do
    run [opt_bin/"searchd", "--config", etc/"manticoresearch/manticore.conf", "--nodetach"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"manticore.conf").write <<~EOS
      searchd {
        pid_file = searchd.pid
        binlog_path=#
      }
    EOS
    pid = fork do
      exec bin/"searchd"
    end
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
