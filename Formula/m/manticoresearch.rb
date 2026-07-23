class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/28.4.4.tar.gz"
  sha256 "10368c731db378edf75b00f291e763ac8e2c7404e12e1256b00b2d1c1c88fbce"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-2.0-only", # wsrep
    { "GPL-2.0-only" => { with: "x11vnc-openssl-exception" } }, # galera
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "11fba865b125498d31a8e0adca9037979886a6474d81d649224b93e3cb01613b"
    sha256 arm64_sequoia: "7d707e2db30d211668ad9a639edf022b85e6ef8ceefbb6578266fa5fbb89a483"
    sha256 arm64_sonoma:  "fcc377a55eecc5181ee993764cb4198d824af9b9c18e16ab2d31ca3eb20d7682"
    sha256 sonoma:        "e95e88bf9448a820beb1a48f91cd3f09054465513ce84c81ba27b62bf3938944"
    sha256 arm64_linux:   "79c3a060250ae96e71b54d6bd1d53925ad53891ca8039d1225fce3fab5a3326f"
    sha256 x86_64_linux:  "312e1245686bfb44096f0ff124467258bf797d622a0ea69eac57ee16e2dd2a6b"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "mcl" do
    url "https://github.com/manticoresoftware/columnar/archive/dd160f109e59c3566e0208fdd6ed8e9f654e2573.tar.gz"
    version "dd160f109e59c3566e0208fdd6ed8e9f654e2573"
    sha256 "a1b34be74f787e19d97d74b7171babba99b35784eb3e2975ff94e767e70e6268"

    livecheck do
      url "https://api.github.com/repos/manticoresoftware/manticoresearch/contents/mcl?ref=#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  # Workarounds for building with Boost 1.89+ and GCC, until fixed upstream:
  # - galera: disable Boost (Boost.System stub removed in 1.89)
  #   Issue ref: https://github.com/manticoresoftware/manticoresearch/issues/3673
  # - searchdbuddy: include Boost.Process v1 environment header
  #   (`<boost/process.hpp>` now pulls Process v2 where `environment` is a namespace)
  # - sortergroup: drop redundant `using` that GCC rejects as private
  patch :DATA

  def install
    resource("mcl").stage buildpath/"mcl"

    # Avoid statically linking to boost
    inreplace "src/CMakeLists.txt", "set ( Boost_USE_STATIC_LIBS ON )", "set ( Boost_USE_STATIC_LIBS OFF )"

    ENV["ICU_ROOT"] = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                          .to_formula.opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = formula_opt_prefix("openssl@3").to_s
    ENV["PostgreSQL_ROOT"] = formula_opt_prefix("libpq").to_s

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
      -DMYSQL_CONFIG_EXECUTABLE=#{formula_opt_bin("mariadb-connector-c")}/mariadb_config
      -DRE2_LIBRARY=#{formula_opt_lib("re2")/shared_library("libre2")}
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
diff --git a/src/searchdbuddy.cpp b/src/searchdbuddy.cpp
index 39985f6..9c83062 100644
--- a/src/searchdbuddy.cpp
+++ b/src/searchdbuddy.cpp
@@ -24,6 +24,7 @@
 #include <boost/process/v1/error.hpp>
 #include <boost/process/v1/handles.hpp>
 #include <boost/process/v1/io.hpp>
+#include <boost/process/v1/env.hpp>
 #else
 #include <boost/process.hpp>
 #endif
diff --git a/src/sortergroup.cpp b/src/sortergroup.cpp
index 13c4feb..d1f91ad 100644
--- a/src/sortergroup.cpp
+++ b/src/sortergroup.cpp
@@ -347,7 +347,6 @@ protected:
 	using BaseGroupSorter_c::AggrSetup;
 	using BaseGroupSorter_c::AggrUpdate;
 	using BaseGroupSorter_c::AggrUngroup;
-	using BaseGroupSorter_c::AggrDiscard;
 
 	using CSphMatchQueueTraits::m_iSize;
 	using CSphMatchQueueTraits::m_dData;
