class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/microsoft/cpprestsdk"
  # do not pull bundled libraries in submodules
  url "https://github.com/microsoft/cpprestsdk/archive/refs/tags/v2.10.19.tar.gz"
  sha256 "4b0d14e5bfe77ce419affd253366e861968ae6ef2c35ae293727c1415bd145c8"
  license "MIT"
  revision 2
  head "https://github.com/microsoft/cpprestsdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9640d605200200ae3d237d25c4331dbba2966b4581caff255f36a6ee4afe342b"
    sha256 cellar: :any,                 arm64_sonoma:  "7be58510e079c21e8521cbd6d8abcc72aa21e6253050b60b47cc4796b7a80ed5"
    sha256 cellar: :any,                 arm64_ventura: "18cca4c9e3e5beb9e777729aab6b8f0bada951a3e4ea7605137c810e248b9a1e"
    sha256 cellar: :any,                 sonoma:        "fe4b73f785105a59749145114cba254a60729d80cb018e949fb1c2e1b32e84ff"
    sha256 cellar: :any,                 ventura:       "e644df4a3ff8db4487036eafbdd520bcf9479b6fe120845c6aaf400a81938d43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07bc8aca63500a0b774984258086a28b5406b67814e9ce62e335b9e2edf8eb28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1703233871c829af74138257f48fa690602ea45f7d7084a0acbd163a4c6db494"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # Apply vcpkg patch to support Boost 1.87.0+
  # Issue ref: https://github.com/microsoft/cpprestsdk/issues/1815
  # Issue ref: https://github.com/microsoft/cpprestsdk/issues/1323
  patch do
    url "https://raw.githubusercontent.com/microsoft/vcpkg/566f9496b7e00ee0cc00aca0ab90493d122d148a/ports/cpprestsdk/fix-asio-error.patch"
    sha256 "8fa4377a86afb4cdb5eb2331b5fb09fd7323dc2de90eb2af2b46bb3585a8022e"
  end

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
        web::http::client::http_client client(U("https://example.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    CPP
    boost = Formula["boost"]
    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{boost.include}", "-I#{Formula["openssl@3"].include}", "-I#{include}",
                    "-L#{boost.lib}", "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                    "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono", "-lboost_thread",
                    "-lboost_system", "-lboost_filesystem", "-lcpprest",
                    "-o", "test_cpprest"
    assert_match "<title>Example Domain</title>", shell_output("./test_cpprest")
  end
end
