class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/15.1.0.tar.gz"
  sha256 "2f654c8ee52e0cd47b0d665d5aafe39a5641f4d6e81bb16e6bad008b72023a6c"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-2.0-only", # wsrep
    { "GPL-2.0-only" => { with: "x11vnc-openssl-exception" } }, # galera
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  revision 1
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
    sha256 arm64_tahoe:   "21dc5c9692aab9f60a81b5dd65d68bbda1f1660c992c2367783d3875fff4b78d"
    sha256 arm64_sequoia: "880b1636f705bf35547eb042e33017db4acd5693718343a1b3b3b730cc7b78a1"
    sha256 arm64_sonoma:  "9606e7f9557cc3c8d79bcd62a91a82d59563ba38be25420bb55f61144279416f"
    sha256 sonoma:        "2d9bf9d56e44d262030e911c962391d386c090fc0d804cf2c100f951fd440a18"
    sha256 arm64_linux:   "73d89c31b7c7ae62be926b46b6134c6166fed9cde4652924b04a01b4e08fe4d0"
    sha256 x86_64_linux:  "9d3b2dee5f420ecfbafe599c8303c195823ce402e9ac3a586967c422ca257b87"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mariadb-connector-c`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@78"
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
  uses_from_macos "zlib"

  # Workaround for Boost 1.89.0 until fixed upstream.
  # Issue ref: https://github.com/manticoresoftware/manticoresearch/issues/3673
  patch :DATA

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

    (var/"run/manticore").mkpath
    (var/"log/manticore").mkpath
    (var/"manticore/data").mkpath
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
