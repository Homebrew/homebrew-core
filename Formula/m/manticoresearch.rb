class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  license all_of: [
    "GPL-3.0-or-later",
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "main"

  stable do
    url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/32.1.3.tar.gz"
    sha256 "3261be44aea2e8998a20602c2780dca96c1a00780b5115ca7a2535a9e9ed3e9f"

    resource "mcl" do
      url "https://github.com/manticoresoftware/columnar/archive/12f86b4299dcef1495972838b76931bf46e4426f.tar.gz"
      version "12f86b4299dcef1495972838b76931bf46e4426f"
      sha256 "54c4e48e283280eabbe664627bd6d1cb07306e6a8bf3fe9557dc366f1a9213f0"

      livecheck do
        url "https://api.github.com/repos/manticoresoftware/manticoresearch/contents/mcl?ref=#{LATEST_VERSION}"
        strategy :json do |json|
          json["sha"]
        end
      end
    end
  end

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    manifest_sha256 "8f632e216b1182e5774d97a45a2d13917a304d69c4ed37437b0218736b890aff"
    sha256 arm64_golden_gate: "ed6ebd45d8e46bf2ff2d553019b76f230e777feff8f182582dc6b90cad42c6ad"
    sha256 arm64_tahoe:       "9af03c4f255de6af0f996efb40fa4015262397e619793af3d216b0c443ebdf2d"
    sha256 arm64_sequoia:     "d71b79ef5fdf860e4a8ae7bf79e6baca4926f39fb91695ebea3e3d155f959aa5"
    sha256 arm64_linux:       "f6a211268470a276a22b56ed66dde7fc141b1dc25e53850e73be69ca81881124"
    sha256 x86_64_linux:      "204ed88e38f0209095b30e3dd6b3fc501c58bbf51cb119b065bdf96320f6bbfd"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  depends_on "boost"
  depends_on "cctz"
  depends_on "croaring"
  depends_on "icu4c@79"
  depends_on "libpq" => :no_linkage
  depends_on "mariadb-connector-c" => :no_linkage
  depends_on "openssl@4"
  depends_on "re2"
  depends_on "unixodbc" => :no_linkage
  depends_on "xxhash"
  depends_on "zstd" => :no_linkage

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "expat" => :no_linkage

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "uni-algo" do
    url "https://github.com/manticoresoftware/uni-algo/archive/refs/tags/v0.7.2.tar.gz"
    sha256 "4df3a10b6f9f0cc3be98834f09100c822ba3e3be13e9dfd23cf4810ed229633f"

    livecheck do
      url "https://raw.githubusercontent.com/manticoresoftware/manticoresearch/refs/tags/release-#{LATEST_VERSION}/cmake/GetUniAlgo.cmake"
      regex(%r{UNIALGO_GITHUB.*?/v?(\d+(?:\.\d+)+)\.t}i)
    end
  end

  # Workarounds for building with Boost 1.89+ and GCC, until fixed upstream:
  # - searchdbuddy: include Boost.Process v1 environment header
  #   (`<boost/process.hpp>` now pulls Process v2 where `environment` is a namespace)
  #   TODO: Remove in the next release.
  # - sortergroup: drop redundant `using` that GCC rejects as private
  # - searchdssl: support OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def install
    resource("mcl").stage("mcl") if build.stable?

    resource("uni-algo").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"uni-algo")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      ENV.append_path "CMAKE_PREFIX_PATH", buildpath/"uni-algo"
    end

    # Avoid statically linking to boost and openssl
    inreplace "src/CMakeLists.txt", "set ( Boost_USE_STATIC_LIBS ON )", "set ( Boost_USE_STATIC_LIBS OFF )"
    inreplace "CMakeLists.txt", "set ( OPENSSL_USE_STATIC_LIBS ON )", "set ( OPENSSL_USE_STATIC_LIBS OFF )"

    ENV["ICU_ROOT"] = dep("icu4c").opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = dep("openssl").opt_prefix.to_s
    ENV["PostgreSQL_ROOT"] = formula_opt_prefix("libpq").to_s

    args = %W[
      -DDISTR_BUILD=homebrew
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_REQUIRE_FIND_PACKAGE_ICU=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_cctz=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_nlohmann_json=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_re2=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_roaring=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_stemmer=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_xxHash=ON
      -DMYSQL_CONFIG_EXECUTABLE=#{formula_opt_bin("mariadb-connector-c")}/mariadb_config
      -DRE2_LIBRARY=#{formula_opt_lib("re2")}/#{shared_library("libre2")}
      -DWITH_GALERA=OFF
      -DWITH_JIEBA=OFF
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
    port = free_port
    (testpath/"data").mkpath
    (testpath/"binlog").mkpath
    (testpath/"manticore.conf").write <<~EOS
      searchd {
        listen = 127.0.0.1:#{port}:http
        log = #{testpath}/searchd.log
        pid_file = #{testpath}/searchd.pid
        data_dir = #{testpath}/data
        binlog_path = #{testpath}/binlog
      }
    EOS

    query = lambda do |sql, retry_connection: false|
      args = %w[--silent --show-error --fail]
      # The first `searchd` launch on CI macOS VMs can spend 20s+ in dyld loading its many `abseil` dylibs
      args += %w[--retry 60 --retry-connrefused --retry-delay 1] if retry_connection
      system "curl", *args, "--output", testpath/"response.json",
                     "--data-urlencode", "query=#{sql}", "--data", "mode=raw",
                     "http://127.0.0.1:#{port}/sql"
      response = JSON.parse((testpath/"response.json").read).first
      assert_equal "", response.fetch("error")
      response
    end

    pid = spawn bin/"searchd", "--config", testpath/"manticore.conf", "--nodetach"
    begin
      query.call("SHOW TABLES", retry_connection: true)
      query.call("CREATE TABLE abi_test(body text, group_id uint)")
      query.call("INSERT INTO abi_test(id,body,group_id) VALUES" \
                 "(1,'roaring bitmap test',7),(2,'unrelated document',8)")
      matches = query.call("SELECT id FROM abi_test WHERE MATCH('bitmap') AND group_id=7")
      assert_equal [{ "id" => 1 }], matches.fetch("data")
      assert_empty query.call("SELECT id FROM abi_test WHERE MATCH('bitmap') AND group_id=8").fetch("data")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
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
diff --git a/src/searchdssl.cpp b/src/searchdssl.cpp
index 5d947f949..7a270d97d 100644
--- a/src/searchdssl.cpp
+++ b/src/searchdssl.cpp
@@ -261,9 +261,11 @@ static bool GenerateInMemorySslKeys ( CSphString & sSslCert, CSphString & sSslKe
 	X509_set_pubkey ( pCert.get(), pKey.get() );
 
 	// subject and issuer name (self-signed)
-	X509_NAME * pName = X509_get_subject_name ( pCert.get() );
+	X509_NAME * pName = X509_NAME_new();
 	X509_NAME_add_entry_by_txt ( pName, "CN", MBSTRING_ASC, (const BYTE *)"ManticoreSoftwareLTD", -1, -1, 0);
+	X509_set_subject_name ( pCert.get(), pName );
 	X509_set_issuer_name ( pCert.get(), pName );
+	X509_NAME_free ( pName );
 
 	// extensions for TLS server certificate
 	if ( !AddCertExtension ( pCert.get(), NID_subject_alt_name, "IP:127.0.0.1,DNS:localhost" ) || !AddCertExtension ( pCert.get(), NID_basic_constraints, "critical,CA:FALSE" ) || !AddCertExtension ( pCert.get(), NID_key_usage, "critical,digitalSignature,keyEncipherment" ) )
