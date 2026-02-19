class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/microsoft/cpprestsdk"
  # do not pull bundled libraries in submodules
  url "https://github.com/microsoft/cpprestsdk/archive/refs/tags/v2.10.19.tar.gz"
  sha256 "4b0d14e5bfe77ce419affd253366e861968ae6ef2c35ae293727c1415bd145c8"
  license "MIT"
  revision 4
  head "https://github.com/microsoft/cpprestsdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3490b01defba37b82b788cef763a32d394ac72a3036fb80f7c85b717cf3e9e4"
    sha256 cellar: :any,                 arm64_sequoia: "326dec0d7be0b1004f74ee9b4909445a519412778ca302ce9b1c21273c1e1494"
    sha256 cellar: :any,                 arm64_sonoma:  "53d492f25bbae3750a7ceae18b47273988b261b038af74946728def83eb54957"
    sha256 cellar: :any,                 sonoma:        "d7304db7e5240b7cbacde6ae229c233ccb89bb77d5b7756d48ea662c8448a7d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6241e1c9cccd4b2ecc7bdb739a3c90aaafb0823455b1348d093db9f6270ea500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810d1b3b84f31d6a55dc8fa8f2b757a97dd4d2f2479a7a1d34da7b0069dce398"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "openssl@3"

  # Apply FreeBSD patches for libc++ >= 19 needed in Xcode 16.3
  # https://github.com/microsoft/cpprestsdk/pull/1829
  on_sequoia :or_newer do
    patch do
      url "https://github.com/microsoft/cpprestsdk/commit/d17f091b5a753b33fb455e92b590fc9f4e921119.patch?full_index=1"
      sha256 "bc68dd08310ba22dc5ceb7506c86a6d4c8bfefa46581eea8cd917354a8b8ae34"
    end
    patch do
      url "https://github.com/microsoft/cpprestsdk/commit/6df13a8c0417ef700c0f164bcd0686ad46f66fd9.patch?full_index=1"
      sha256 "4205e818f5636958589d2c1e5841a31acfe512eda949d63038e23d8c089a9636"
    end
    patch do
      url "https://github.com/microsoft/cpprestsdk/commit/4188ad89b2cf2e8de3cc3513adcf400fbfdc5ce7.patch?full_index=1"
      sha256 "3bc72590cbaf6d04e3e5230558647e5b38e7f494cd0e5d3ea5c866ac25f9130a"
    end
    patch do
      url "https://github.com/microsoft/cpprestsdk/commit/32b322b564e5e540ff02393ffe3bd3bade8d299c.patch?full_index=1"
      sha256 "737567e533405f7f6ef0a83bafef7fdeea95c96947f66be0973e5f362e1b82f5"
    end
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply vcpkg patch to support Boost 1.87.0+
  # Issue ref: https://github.com/microsoft/cpprestsdk/issues/1815
  # Issue ref: https://github.com/microsoft/cpprestsdk/issues/1323
  patch do
    url "https://raw.githubusercontent.com/microsoft/vcpkg/566f9496b7e00ee0cc00aca0ab90493d122d148a/ports/cpprestsdk/fix-asio-error.patch"
    sha256 "8fa4377a86afb4cdb5eb2331b5fb09fd7323dc2de90eb2af2b46bb3585a8022e"
  end

  # Workaround to build with Boost 1.89.0
  patch :DATA

  def install
    system "cmake", "-S", "Release", "-B", "build",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    # Disable websockets feature due to https://github.com/zaphoyd/websocketpp/issues/1157
                    # Needs upstream response and fix in `websocketpp` formula (do not use bundled copy)
                    "-DCPPREST_EXCLUDE_WEBSOCKETS=ON",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
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
    boost = Formula["boost"]
    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{boost.include}", "-I#{Formula["openssl@3"].include}", "-I#{include}",
                    "-L#{boost.lib}", "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                    "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono", "-lboost_thread",
                    "-lboost_filesystem", "-lcpprest",
                    "-o", "test_cpprest"
    assert_match "The Missing Package Manager for macOS (or Linux)", shell_output("./test_cpprest")
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
