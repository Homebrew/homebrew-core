class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  license "GPL-2.0-only"
  revision 1
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
    sha256 arm64_monterey: "0d31819a20010dd00d54cd895a1b9afc7da46fbb6d7650b83f1d6388676d8583"
    sha256 arm64_big_sur:  "da661fd25ac664003e7ebe7837ea6f1904884b8926e3365fd424e9b4a04b52c8"
    sha256 monterey:       "bf3d26100dc52e4db781a92dd78da63486e1f0ab1b61845ae08c46fe68a1cef6"
    sha256 big_sur:        "697b60f5f866ef32d24225286bf6a87da48481359b93a858b8806f2cdf832d81"
    sha256 catalina:       "9546799a9aefe73f36368839ae8d00c31c4aca4046771cf72e327063b6c420c8"
    sha256 x86_64_linux:   "ce6a2f0ce1bd4dabc0eb3dedff7b5ba24a7351a4d6318e424b2a9253459cf6f0"
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
