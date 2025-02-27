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
  revision 1
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d*[02468])$/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "23b9f82bba64cd82f47fe1df8c2bcd76563a8270e5ea27d50a2fad2ba5703889"
    sha256 arm64_sonoma:  "03245d85200575b4e4c87842cf0ebe41b63be66a48dce4d5ec391230ad9c26b5"
    sha256 arm64_ventura: "94753adf68046638f9773fc1c893629d46409f092982354e929a66b480b23217"
    sha256 sonoma:        "9ca10dd355103c9d92272466583836b43e2b2feba151448051a0238a7505ee7a"
    sha256 ventura:       "b9bd3aa87501c7b4acc03ec4f0afe0d85736fd19c9234e79ea26ccf46d94f12a"
    sha256 x86_64_linux:  "295595ebca01296aabcf0b686ffc589df0ec829ac07c601ad53079b0b090be15"
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

  # Allow building with Boost 1.87.0. Issue reported upstream following CONTRIBUTING.md
  # Issue ref: https://github.com/manticoresoftware/manticoresearch/issues/3099
  patch :DATA

  def install
    # Avoid statically linking to boost
    inreplace "src/CMakeLists.txt", "set ( Boost_USE_STATIC_LIBS ON )", "set ( Boost_USE_STATIC_LIBS OFF )"

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

__END__
diff --git a/src/searchdbuddy.cpp b/src/searchdbuddy.cpp
index 7faf78557..36f030edc 100644
--- a/src/searchdbuddy.cpp
+++ b/src/searchdbuddy.cpp
@@ -14,7 +14,7 @@
 #include "netreceive_ql.h"
 #include "client_session.h"
 
-#include <boost/asio/io_service.hpp>
+#include <boost/asio/io_context.hpp>
 #include <boost/asio/read_until.hpp>
 #include <boost/process.hpp>
 #if _WIN32
@@ -32,7 +32,7 @@ static CSphString g_sUrlBuddy;
 static CSphString g_sStartArgs;
 
 static const int PIPE_BUF_SIZE = 2048;
-static std::unique_ptr<boost::asio::io_service> g_pIOS;
+static std::unique_ptr<boost::asio::io_context> g_pIOS;
 static std::vector<char> g_dPipeBuf ( PIPE_BUF_SIZE );
 static CSphVector<char> g_dLogBuf ( PIPE_BUF_SIZE );
 static std::unique_ptr<boost::process::async_pipe> g_pPipe;
@@ -357,7 +357,7 @@ BuddyState_e TryToStart ( const char * sArgs, CSphString & sError )
 	g_pPipe.reset();
 	g_pIOS.reset();
 
-	g_pIOS.reset ( new boost::asio::io_service );
+	g_pIOS.reset ( new boost::asio::io_context );
 	g_pPipe.reset ( new boost::process::async_pipe ( *g_pIOS ) );
 
 	std::unique_ptr<boost::process::child> pBuddy;
