class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/6.0.4.tar.gz"
  sha256 "5081f4f60152d041f14fdaf993f4cc67b127e76c970b58db9bc9532cd1325d8a"
  license "GPL-2.0-only"
  revision 2
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d*[02468])$/i)
  end

  bottle do
    sha256 arm64_ventura:  "382659914489e64dd2771386eec177c354dae58fe39d1079c412449129945a58"
    sha256 arm64_monterey: "b56a169ed02a580e6ee0db4ce5733dd4834d2f2222b3f467516a674ccf5db566"
    sha256 arm64_big_sur:  "3304df12246dc8a9f6d42326314d15a6b53868e861d19199b5fe03d0c7678a44"
    sha256 ventura:        "f61a87c738bff32816b0603dfb4c436315460b67dbde81e2e59be44267167b6a"
    sha256 monterey:       "f5ee8de69414f39de8115ee0c03a1b01b642a3de66e7bf2708f3d53dc0f6c637"
    sha256 big_sur:        "4725718f3048471a5fb43c797896818e24a89b63b91ca719a5f04b6a202f8f23"
    sha256 x86_64_linux:   "1f42805be6d88b8bff08136540e27bfd593115698506fa79e257f97ff3375725"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "libpq"
  depends_on "mysql-client"
  depends_on "openssl@3"
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
