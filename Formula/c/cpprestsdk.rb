class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/microsoft/cpprestsdk"
  # do not pull bundled libraries in submodules
  url "https://github.com/microsoft/cpprestsdk/archive/refs/tags/v2.10.19.tar.gz"
  sha256 "4b0d14e5bfe77ce419affd253366e861968ae6ef2c35ae293727c1415bd145c8"
  license "MIT"
  revision 6
  head "https://github.com/microsoft/cpprestsdk.git", branch: "master"

  bottle do
    manifest_sha256 "3beee3586c89171ae1ef8022ede458e76c20c26f778bcfabca043162dcef4f86"
    sha256 cellar: :any, arm64_golden_gate: "4374610a899c5fccfae72e8046214524e44efdee0dd6917f48d29796c9ac6922"
    sha256 cellar: :any, arm64_tahoe:       "eba8604e61c0fbb86a6454d67d055eb04b9fbaec2d1f5cff061226e30f179e74"
    sha256 cellar: :any, arm64_sequoia:     "0a2e8da8a13011eeb13977160d588f246ef4af7529a913663ca96dd6ca93cec8"
    sha256 cellar: :any, arm64_linux:       "dbacd6afc0e299e42d21c98a9223137e2db980dad16223f9d453f430448797e7"
    sha256 cellar: :any, x86_64_linux:      "78497093bf3b7b0c294b1a126ab591f3c819ebb2f9ed8d2402feb2fa522f1908"
  end

  # https://github.com/microsoft/cpprestsdk/commit/7c3f8782e36303c896d1b75a9d23160d4e76b4c7
  deprecate! date: "2026-06-12", because: :repo_archived
  disable! date: "2027-06-12", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost" => :no_linkage
  depends_on "openssl@4"

  # Apply FreeBSD patches for libc++ >= 19 needed in Xcode 16.3
  on_sequoia :or_newer do
    patch do
      url "https://github.com/microsoft/cpprestsdk/commit/d17f091b5a753b33fb455e92b590fc9f4e921119.patch?full_index=1"
      sha256 "bc68dd08310ba22dc5ceb7506c86a6d4c8bfefa46581eea8cd917354a8b8ae34"
      type :unofficial
      resolves "https://github.com/microsoft/cpprestsdk/pull/1829"
    end
    patch do
      url "https://github.com/microsoft/cpprestsdk/commit/6df13a8c0417ef700c0f164bcd0686ad46f66fd9.patch?full_index=1"
      sha256 "4205e818f5636958589d2c1e5841a31acfe512eda949d63038e23d8c089a9636"
      type :unofficial
      resolves "https://github.com/microsoft/cpprestsdk/pull/1829"
    end
    patch do
      url "https://github.com/microsoft/cpprestsdk/commit/4188ad89b2cf2e8de3cc3513adcf400fbfdc5ce7.patch?full_index=1"
      sha256 "3bc72590cbaf6d04e3e5230558647e5b38e7f494cd0e5d3ea5c866ac25f9130a"
      type :unofficial
      resolves "https://github.com/microsoft/cpprestsdk/pull/1829"
    end
    patch do
      url "https://github.com/microsoft/cpprestsdk/commit/32b322b564e5e540ff02393ffe3bd3bade8d299c.patch?full_index=1"
      sha256 "737567e533405f7f6ef0a83bafef7fdeea95c96947f66be0973e5f362e1b82f5"
      type :unofficial
      resolves "https://github.com/microsoft/cpprestsdk/pull/1829"
    end
  end

  # Apply vcpkg patch to support Boost 1.87.0+
  patch do
    url "https://raw.githubusercontent.com/microsoft/vcpkg/566f9496b7e00ee0cc00aca0ab90493d122d148a/ports/cpprestsdk/fix-asio-error.patch"
    sha256 "8fa4377a86afb4cdb5eb2331b5fb09fd7323dc2de90eb2af2b46bb3585a8022e"
    type :unofficial
    resolves "https://github.com/microsoft/cpprestsdk/issues/1815",
             "https://github.com/microsoft/cpprestsdk/issues/1323"
  end

  # Workaround to build with Boost 1.89.0
  patch :DATA

  allow_network_access! :test

  def install
    openssl_prefix = dep("openssl").opt_prefix
    args = [
      "-DBUILD_SAMPLES=OFF",
      "-DBUILD_TESTS=OFF",
      # Disable websockets feature due to https://github.com/zaphoyd/websocketpp/issues/1157
      # Needs upstream response and fix in `websocketpp` formula (do not use bundled copy)
      "-DCPPREST_EXCLUDE_WEBSOCKETS=ON",
      "-DOPENSSL_ROOT_DIR=#{openssl_prefix}",
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # strip boost linkage

    system "cmake", "-S", "Release", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <iostream>
      #include <cpprest/http_client.h>
      int main() {
        web::http::client::http_client client(U("https://brew.sh/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    CPP
    openssl = dep("openssl")
    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{formula_opt_include("boost")}", "-I#{openssl.opt_include}", "-I#{include}",
                    "-L#{formula_opt_lib("boost")}", "-L#{openssl.opt_lib}", "-L#{lib}",
                    "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono", "-lboost_thread",
                    "-lboost_filesystem", "-lcpprest",
                    "-o", "test_cpprest"
    assert_match "The Package Manager for Everywhere", shell_output("./test_cpprest")
  end
end

__END__
diff --git a/Release/cmake/cpprest_find_boost.cmake b/Release/cmake/cpprest_find_boost.cmake
index 3c857baf..60158173 100644
--- a/Release/cmake/cpprest_find_boost.cmake
+++ b/Release/cmake/cpprest_find_boost.cmake
@@ -46,7 +46,7 @@ function(cpprest_find_boost)
     endif()
     cpprestsdk_find_boost_android_package(Boost ${BOOST_VERSION} EXACT REQUIRED COMPONENTS random system thread filesystem chrono atomic)
   elseif(UNIX)
-    find_package(Boost REQUIRED COMPONENTS random system thread filesystem chrono atomic date_time regex)
+    find_package(Boost REQUIRED COMPONENTS random thread filesystem chrono atomic date_time regex)
   else()
     find_package(Boost REQUIRED COMPONENTS system date_time regex)
   endif()
@@ -88,7 +88,6 @@ function(cpprest_find_boost)
       target_link_libraries(cpprestsdk_boost_internal INTERFACE
         Boost::boost
         Boost::random
-        Boost::system
         Boost::thread
         Boost::filesystem
         Boost::chrono
diff --git a/Release/cmake/cpprestsdk-config.in.cmake b/Release/cmake/cpprestsdk-config.in.cmake
index 72476b06..811e79ac 100644
--- a/Release/cmake/cpprestsdk-config.in.cmake
+++ b/Release/cmake/cpprestsdk-config.in.cmake
@@ -17,9 +17,9 @@ endif()
 
 if(@CPPREST_USES_BOOST@)
   if(UNIX)
-    find_dependency(Boost COMPONENTS random system thread filesystem chrono atomic date_time regex)
+    find_dependency(Boost COMPONENTS random thread filesystem chrono atomic date_time regex)
   else()
-    find_dependency(Boost COMPONENTS system date_time regex)
+    find_dependency(Boost COMPONENTS date_time regex)
   endif()
 endif()
 include("${CMAKE_CURRENT_LIST_DIR}/cpprestsdk-targets.cmake")
