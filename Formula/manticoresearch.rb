class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  license "GPL-2.0-only"
  revision 1
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # NOTE: Do not update to odd patch version (e.g. 5.0.3)
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
    rebuild 1
    sha256 arm64_monterey: "6ebf0abdffbc69f06fa43402252807519b7e9da2c0281033f3d4c87d2ae82d2e"
    sha256 arm64_big_sur:  "28e7b473c160b1fbf517e414ea532d74c2feb94c80b4477671bbdf7061411831"
    sha256 monterey:       "691f70444945411c93901e5c844ae1a5ec102da0393efc4432e89da252321831"
    sha256 big_sur:        "442dd3d22eb60d8eb82827afdc068d64e0b397043e77a6986c2412565b9d6b3f"
    sha256 catalina:       "7be8a32ffc536604ba887171af12757f2b146e202776be1c593625a2e93ee0f7"
    sha256 x86_64_linux:   "793c494a5d422ba66bc4e997c749fa815552e1683c8daffe82ab2f147e86793f"
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
