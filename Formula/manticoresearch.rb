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
    sha256 arm64_monterey: "06bebc9c1ac2ca722dda99885d5157dfaf369311d5fee875746f08aadea40028"
    sha256 arm64_big_sur:  "50d35bf3d23482bb5b8667d4017c030b2635f2fcc3f1a5dc82e3f738382d7ac9"
    sha256 monterey:       "360caa77c18f7578c09d28a537f80708ffbc5b07f2481deac1ae4175de5e105d"
    sha256 big_sur:        "170351c742a0942ac1c56108c8d58feef9ccca906cba72316e887c6eb8c875c1"
    sha256 catalina:       "7698255e8b7e7781402b3ff2e3168f6f26f60beb994a01ce6864ed067228a8bc"
    sha256 x86_64_linux:   "609611a0c37c36f012ab85034e3bed51ca3b53e378ffb2de0e121b534a374fc1"
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
