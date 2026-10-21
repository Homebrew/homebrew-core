class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  license all_of: [
    "GPL-3.0-or-later",
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  revision 2
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "main"

  stable do
    url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/29.9.0.tar.gz"
    sha256 "e1dc58dc671e74278a6ab5327c2fc666d75ae3ad6fbc59587f60376043f3cb4e"

    resource "mcl" do
      url "https://github.com/manticoresoftware/columnar/archive/cb282a2442d2d51349fbea67cda97c2dda37f0bd.tar.gz"
      version "cb282a2442d2d51349fbea67cda97c2dda37f0bd"
      sha256 "5d444222405c00ce21f3a360e5983b140247f43b18c7f01b85d4b564e87a8432"

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
    sha256 arm64_golden_gate: "0923f5b6eadf34697fc478fccce0221b7876f76381278f1cc49036c493e9c3a3"
    sha256 arm64_tahoe:       "d07a13884658435b6376a6c031c656e7628b84285d936353902d868819b6047f"
    sha256 arm64_sequoia:     "7f83ed8151c4a68651e6ebabf0aecb1869d65eb7f6f0ed01d3cec36316424860"
    sha256 arm64_linux:       "9ec9be6b7b4fa65a5e45883811c7f1e8685df8ca796d595c37cf573849f6e4b7"
    sha256 x86_64_linux:      "5372b3eaaeb6112d29d98bde4be95b8e60131dee671cbe6633f7a6d206dfaa6d"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mariadb-connector-c`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "boost"
  depends_on "cctz"
  depends_on "croaring"
  depends_on "icu4c@78"
  depends_on "libpq"
  depends_on "mariadb-connector-c"
  depends_on "openssl@4"
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

  deny_network_access!

  def install
    resource("mcl").stage("mcl") if build.stable?

    resource("uni-algo").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"uni-algo")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      ENV.append_path "CMAKE_PREFIX_PATH", buildpath/"uni-algo"
    end

    # Avoid statically linking to boost
    inreplace "src/CMakeLists.txt", "set ( Boost_USE_STATIC_LIBS ON )", "set ( Boost_USE_STATIC_LIBS OFF )"

    ENV["ICU_ROOT"] = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                          .to_formula.opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = formula_opt_prefix("openssl@4").to_s
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
      -DRE2_LIBRARY=#{formula_opt_lib("re2")/shared_library("libre2")}
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
