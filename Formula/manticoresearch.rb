class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/5.0.3.tar.gz"
  sha256 "416b9e609529af9cf9570b41e3e770de9511c5ed4d0c27530bfec7da396b13b2"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "575748eaa4348edd17c1dd190e22920f3ea9667a1188e7e74265f1635af0028b"
    sha256 arm64_monterey: "c65ef528860f95e99def3e27916209eaf395ebe8e33b1a3d91795efe2eaf2a46"
    sha256 arm64_big_sur:  "e887e81f3b3fa6899be543d98c1d4812d2a2f1e7c2318b977a9d287e40e25381"
    sha256 ventura:        "889816f150009cb9b0346f0b7005f383b6a68ea809248669b0e4d3bc08c4753c"
    sha256 monterey:       "3f6fee4d64aa86474fbba738c46c227bcd217d9e11d4219811445756dcab6e33"
    sha256 big_sur:        "caa74f1c482f7ef4da9b88787bda384a8cc04e89a6ec11e0a97ecebff0a88510"
    sha256 catalina:       "09befd5ca1cd25be42b1937f91f74a2a1086545630911c7bd6e8aa24eb067f7c"
    sha256 x86_64_linux:   "ba236c16a5c2d1430a30d9932438d569511f74ae38f37acd18b6cffbdbcefb60"
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
