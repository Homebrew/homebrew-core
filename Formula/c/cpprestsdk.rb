class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/microsoft/cpprestsdk"
  # do not pull bundled libraries in submodules
  url "https://github.com/microsoft/cpprestsdk/archive/refs/tags/v2.10.19.tar.gz"
  sha256 "4b0d14e5bfe77ce419affd253366e861968ae6ef2c35ae293727c1415bd145c8"
  license "MIT"
  revision 3
  head "https://github.com/microsoft/cpprestsdk.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e077422f309a8ed21fa46f8a1ffefcba57b2b394b0e9cf501b62d62f214e067"
    sha256 cellar: :any,                 arm64_sequoia: "308579b3f28e24db2678b00d3f2c0ca285fc47eacd8a2fddf35f2404562b142c"
    sha256 cellar: :any,                 arm64_sonoma:  "01eb9f54ecdc29035230667a6beb5adc50940dc3f52169334394d1c7e8cc08c9"
    sha256 cellar: :any,                 arm64_ventura: "3cd4baefa8081807c066f32526e4292e4692482ab7e59f3b101ed8176bf47213"
    sha256 cellar: :any,                 sonoma:        "87bde89b79cd019ab64d60f98df68a31ea20cf6e1a615e6905a5fa57abc149f0"
    sha256 cellar: :any,                 ventura:       "750ea4343b57683dc552cd5a5cae40944dd90595863fa27419e5dbd4fb4fd87f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8464f7f1c4a87916539c39a3c7d1cb6ac5d2a1fd6cc1a8fd16e33cd83fdad88d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24cc62c99aeecd2a910e156a9d39846f757b37d54b385740e6c2d3ea50adbd56"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
