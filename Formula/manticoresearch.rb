class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  stable do
    url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/6.0.0.tar.gz"
    sha256 "3f6ab679a9bddb0672b8f0650ba2024cecfbbc9b7a57917e7dff3ec2073a98ed"

    # Allow system ICU usage and tune build (config from homebrew; release build; don't split symbols).
    # Remove with next release
    patch do
      url "https://github.com/manticoresoftware/manticoresearch/commit/70ede046a1ed.patch?full_index=1"
      sha256 "8c15dc5373898c2788cea5c930c4301b9a21d8dc35d22a1bbb591ddcf94cf7ff"
    end
  end

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d*[02468])$/i)
  end

  bottle do
    sha256 arm64_ventura:  "2cd2c5406f4f464f960a3b2ee67d76988c6a8ace8c1e82db8659623628d9046a"
    sha256 arm64_monterey: "89930dacf6668593f506ec7f2a353e94b0e0b20d141dc116c916d0f4e39bb54c"
    sha256 arm64_big_sur:  "5395826686d53d7213550e84976202a6a78654844db8e322d8b1b19989838061"
    sha256 ventura:        "af1bc06680f36e7526d680e01ca89e9172c8eaf4ca6f02c4b1e319b2ad33a50b"
    sha256 monterey:       "457beeda7981495d4ea609066f35aa90ad9bb65b46acfa19fc2534f3804b19fd"
    sha256 big_sur:        "6edb5cbeddca6fa981682578da0597c7f92698e291401ee2a5b0dc4ecfcc98b4"
    sha256 x86_64_linux:   "9938c37089d9bdb8055ddb6fb70c9872caa098fb4b78150575d3369465c6014f"
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
