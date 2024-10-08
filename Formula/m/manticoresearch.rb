class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/6.3.6.tar.gz"
  sha256 "d0409bde33f4fe89358ad7dbbad775e1499d4e61fed16d4fa84f9b29b89482d2"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-2.0-only", # wsrep
    { "GPL-2.0-only" => { with: "x11vnc-openssl-exception" } }, # galera
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  revision 1
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d*[02468])$/i)
  end

  bottle do
    sha256 arm64_sequoia: "c1d3ba2930306333adf8fb0b520fab4aa1049b8820848ab8ebebf26c65439392"
    sha256 arm64_sonoma:  "62aa91631038e5eb4b927d98348799449b0d0279f682bbb57517aeefeb04a31f"
    sha256 arm64_ventura: "b8967a7b72cdcacf9d52ee55b94da412bafc1fe0ab1a12405758ef1efc9684b9"
    sha256 sonoma:        "d07adf6c1e6a4fbf85e6c0883a961837b3de87e79778b81c1118db8fc661237f"
    sha256 ventura:       "14997a93fa20490c7b3709423817afb9637c27ef47ed4150f729f1d8faecffa7"
    sha256 x86_64_linux:  "4e34dac8b96e920c3e8852afba0ebebc7f1010edff93c9c887d558ad1456a413"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mysql-client`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "cctz"
  depends_on "icu4c@75"
  depends_on "libpq"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "unixodbc"
  depends_on "xxhash"
  depends_on "zlib" # due to `mysql-client`
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2"

  fails_with gcc: "5"

  def install
    # Work around error when building with GCC
    # Issue ref: https://github.com/manticoresoftware/manticoresearch/issues/2393
    ENV.append_to_cflags "-fpermissive" if OS.linux?

    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(/^icu4c@\d+$/) }
    ENV["ICU_ROOT"] = icu4c.opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix.to_s
    ENV["MYSQL_ROOT_DIR"] = Formula["mysql-client"].opt_prefix.to_s
    ENV["PostgreSQL_ROOT"] = Formula["libpq"].opt_prefix.to_s

    args = %W[
      -DDISTR_BUILD=homebrew
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_REQUIRE_FIND_PACKAGE_ICU=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_cctz=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_nlohmann_json=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_re2=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_stemmer=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_xxHash=ON
      -DRE2_LIBRARY=#{Formula["re2"].opt_lib/shared_library("libre2")}
      -DWITH_ICU_FORCE_STATIC=OFF
      -DWITH_RE2_FORCE_STATIC=OFF
      -DWITH_STEMMER_FORCE_STATIC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    pid = spawn(bin/"searchd")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
