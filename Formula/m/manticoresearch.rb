class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/9.2.38.tar.gz"
  sha256 "4f55b8663f18aba3d0f86ef9dced8b96db2c0af9b086c24f188b8db4298771c8"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-2.0-only", # wsrep
    { "GPL-2.0-only" => { with: "x11vnc-openssl-exception" } }, # galera
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d*[02468])$/i)
  end

  bottle do
    sha256 arm64_sequoia: "34ae3d4c3752c94d3f29e96c7e16804f085b54646982b66fae943a46f97a3af3"
    sha256 arm64_sonoma:  "e4d7a333e5d9d5843c36437c068b3b1a0ba436e7d8f3c9387fa4c2239aeb6fdc"
    sha256 arm64_ventura: "2b9db80eea6b516fddcf22116a27c0e60ce22104f721f68443d012af3dee0abb"
    sha256 sonoma:        "c15b7754d1e0f8dad7a33a755354b1061437dca01e9127ba016e7063d1d6a48c"
    sha256 ventura:       "4700f9430155f70bb8b8ae29cd8eb4f95100f69c763cae171b36d343f5701dbe"
    sha256 arm64_linux:   "091b046791a3820a7c1f9fdc34eb32bc3b7ec8c08884eb1370333ef9eb0a8fe7"
    sha256 x86_64_linux:  "034efa1925bc21a0850635720647b8a0a514bc46f493f61be9a54190a8be2c25"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mariadb-connector-c`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@77"
  depends_on "libpq"
  depends_on "mariadb-connector-c"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "unixodbc"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # Avoid statically linking to boost
    inreplace "src/CMakeLists.txt", "set ( Boost_USE_STATIC_LIBS ON )", "set ( Boost_USE_STATIC_LIBS OFF )"

    ENV["ICU_ROOT"] = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                          .to_formula.opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix.to_s
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
      -DMYSQL_CONFIG_EXECUTABLE=#{Formula["mariadb-connector-c"].opt_bin}/mariadb_config
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
