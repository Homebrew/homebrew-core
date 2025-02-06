class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/7.0.0.tar.gz"
  sha256 "7d65ae4c40eb2641474fe7347590684b1a779df66f9d91374836887d486ddfdc"
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
    sha256 arm64_sequoia: "f9cd06d7a60865cb5e903715569159aa0982a43e0c92c88303968d5a6138d1a0"
    sha256 arm64_sonoma:  "5b3ae70847a9f113129794daf5f6334c5bfdb25cb26d9ace58348ff818757d6e"
    sha256 arm64_ventura: "4b34465eb0a51a6c8a1d2e445cb29289e064cefdd01e62d1b494a815ffd0d327"
    sha256 sonoma:        "3eba3b20b169fc783cc4d4263068d4cb4b07f8d6ffa3c4397b71be0a12e6feb7"
    sha256 ventura:       "f885e6069dedf497b1260e584e597d0b75c69ecc3fef89f90b81f858790b37f4"
    sha256 x86_64_linux:  "17b7c8d8284cd3d36691c692675d7a266ac733e410b9beb012b64cd36a515b6c"
  end

  depends_on "boost@1.85" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mariadb-connector-c`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "cctz"
  depends_on "icu4c@76"
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
    # Work around error when building with GCC
    # Issue ref: https://github.com/manticoresoftware/manticoresearch/issues/2393
    ENV.append_to_cflags "-fpermissive" if OS.linux?

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
