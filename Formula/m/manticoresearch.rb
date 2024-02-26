class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/6.2.12.tar.gz"
  sha256 "272d9e3cc162b1fe08e98057c9cf6c2f90df0c3819037e0dafa200e5ff71cef9"
  license "GPL-2.0-only" # License changes in the next release and must be removed from formula_license_mismatches
  revision 1
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d*[02468])$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ebccbe26f5358d4cb0b2e6c077d1cd1676bacdb90704fd74dec1c996b165a0f3"
    sha256 arm64_ventura:  "3ac03e8f29238d750840e583011a3ab5c8fc02814f989463a0baad97ff8b8607"
    sha256 arm64_monterey: "b3ddbd82e0d38c88a2b94658311ec644bbcb293edf77b03ab0fcb3d60995d6f4"
    sha256 sonoma:         "71b25bfabae553885eccb4b147eef6b3bf99e488ec9de422801fd9850d4adbe1"
    sha256 ventura:        "48c8b6624b6bfde3e964eaf9fe4d08d9c778d120a4b78feafeea1f9d0e4815ac"
    sha256 monterey:       "e096ac88ffe59c40e2e2751af85a21a14c49b89c68de4defbfb5bdb54843b5fb"
    sha256 x86_64_linux:   "63f602892d1341f76aef3bd17a5f8f91e6198ae151993ce8b0a5e3297487e957"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "libpq"
  depends_on "mysql-client@8.0"
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
    ENV["MYSQL_ROOT_DIR"] = Formula["mysql-client@8.0"].opt_prefix.to_s
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
