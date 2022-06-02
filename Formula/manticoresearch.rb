class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  stable do
    url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/5.0.2.tar.gz"
    sha256 "ca7828a6841ed8bdbc330516f85ad3a85749998f443b9de319cec60e12c64c07"

    # Allow system ICU usage and tune build (config from homebrew; release build; don't split symbols).
    # Remove with next release

    patch do
      url "https://github.com/manticoresoftware/manticoresearch/commit/70ede046a1ed.patch?full_index=1"
      sha256 "8c15dc5373898c2788cea5c930c4301b9a21d8dc35d22a1bbb591ddcf94cf7ff"
    end
  end

  bottle do
    sha256 arm64_monterey: "f55f960076fbee621f9292de41f671db7aab5587eec035e9ee9060268b3f306c"
    sha256 arm64_big_sur:  "37f16dfb2b31f7dacdc1818a4417f765637c1de051ade808b1123bfba2d125d3"
    sha256 monterey:       "509bc6f6379aad68ad2df404becf0183653b87400d38e3fb897afb6088209939"
    sha256 big_sur:        "717f6d93410c969f7d1c717af610cfc8815548b6835208b5c690639c48a384f0"
    sha256 catalina:       "0595b59292ca6b2e1f947f053720ce4c478111736df58d76048ad43b7bf4cfac"
    sha256 x86_64_linux:   "704acba2d67a0e365ac8f458969be7ba54fed2390797aa6b93fcff1a74bdad96"
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

  on_linux do
    depends_on "gcc"
  end

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
