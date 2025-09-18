class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/13.11.1.tar.gz"
  sha256 "705aa5b1222a448642b51b196f0ea4001e06e26eb2e06b68066a0b822f8f30e3"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-2.0-only", # wsrep
    { "GPL-2.0-only" => { with: "x11vnc-openssl-exception" } }, # galera
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "f97d83a665e43696209f5a24a2cfc8bbbf8d087ce5fc481b10b37a6fc95dae62"
    sha256 arm64_sequoia: "e5bd4089cb77b95e1c102f8b7e1b12eb8aa52fdfc1c0f82d7099827c64a8957c"
    sha256 arm64_sonoma:  "76ddbda78fe3f552241d9f5edd646c9738500c6c4029ca58a062a4e34a39841d"
    sha256 sonoma:        "fd573fa8133c982535d20239a8136db3b087d049d5d8769c22d31ab066411974"
    sha256 arm64_linux:   "4240105fd72b43939d6a9184a87535171cc0da304f54f641ee6fef6b739be46d"
    sha256 x86_64_linux:  "1c61c468419d8e296b5cd9d57ce0a5dde8e29e9233ca2cd545a2ac04e69f9c76"
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

  # Workaround for Boost 1.89.0 until fixed upstream.
  # Issue ref: https://github.com/manticoresoftware/manticoresearch/issues/3673
  patch :DATA

  def install
    # Avoid statically linking to boost
    inreplace "src/CMakeLists.txt", "set ( Boost_USE_STATIC_LIBS ON )", "set ( Boost_USE_STATIC_LIBS OFF )"
    # Fix to error: call to non-‘constexpr’ function
    inreplace "src/sphinxquery/transform_commonkeywords.cpp", "constexpr uint64_t", "inline uint64_t"

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

__END__
diff --git a/cmake/galera-imported.cmake.in b/cmake/galera-imported.cmake.in
index 0ffa9caf1..806c929b4 100644
--- a/cmake/galera-imported.cmake.in
+++ b/cmake/galera-imported.cmake.in
@@ -15,9 +15,9 @@ include ( ExternalProject )
 ExternalProject_Add ( galera_populate
 		URL @GALERA_PLACE@
 		URL_MD5 @GALERA_SRC_MD5@
-		CMAKE_CACHE_ARGS -DWSREP_PATH:STRING=${wsrep_populate_SOURCE_DIR} -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DGALERA_REV:STRING=@GALERA_REV@
+		CMAKE_CACHE_ARGS -DWSREP_PATH:STRING=${wsrep_populate_SOURCE_DIR} -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DGALERA_REV:STRING=@GALERA_REV@ -DWITH_BOOST:BOOL=OFF -DCMAKE_CXX_FLAGS:STRING=-DASIO_DISABLE_BOOST_REGEX=1\ -DBOOST_DATE_TIME_POSIX_TIME_STD_CONFIG=1
 		BUILD_COMMAND "@CMAKE_COMMAND@" --build . --config RelWithDebInfo
 		INSTALL_COMMAND "@CMAKE_COMMAND@" --install . --config RelWithDebInfo --prefix "@GALERA_BUILD@"
 		)
 
-# file configured from cmake/galera-imported.cmake.in
\ No newline at end of file
+# file configured from cmake/galera-imported.cmake.in
