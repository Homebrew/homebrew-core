class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      tag:      "2.10.18",
      revision: "122d09549201da5383321d870bed45ecb9e168c5"
  license "MIT"
  revision 1
  head "https://github.com/Microsoft/cpprestsdk.git", branch: "development"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ecebaabee208c5c7337b1336b710505b865f6f01e45a8c94d2683b29c446bfa4"
    sha256 cellar: :any,                 arm64_monterey: "fbb03884dcf8e1a9206e753e6a0c6d3acfe89d12f6087981bc94c1166ed0ca94"
    sha256 cellar: :any,                 arm64_big_sur:  "fbf9e57e1d1af52cd599dc4888f5183532df41a408384c9025d7d70c45903328"
    sha256 cellar: :any,                 ventura:        "1ba3472004cb4a9ed97ac4ab28cde451ccbc2e3013b229a1ce6d02d049d780d1"
    sha256 cellar: :any,                 monterey:       "aecde5f4fc4863f8ec372744514954850c4adc3138b3d1ea1270d70b662dd7e7"
    sha256 cellar: :any,                 big_sur:        "e4b01652b3928771031ddd5fd36dfb960cc5fcee2e449239ddd9abb6e4d538e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d83163b9b544a0e89f5b45d1cf6e08a103e1e873384bfb3fc6e5164febffd4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"]}.opt_prefix",
                    "Release", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <cpprest/http_client.h>
      int main() {
        web::http::client::http_client client(U("https://example.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    EOS
    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{Formula["boost"].include}", "-I#{Formula["openssl@3"].include}", "-I#{include}",
                    "-L#{Formula["boost"].lib}", "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                    "-lssl", "-lcrypto", "-lboost_random-mt", "-lboost_chrono-mt", "-lboost_thread-mt",
                    "-lboost_system-mt", "-lboost_filesystem-mt", "-lcpprest",
                    "-o", "test_cpprest"
    assert_match "<title>Example Domain</title>", shell_output("./test_cpprest")
  end
end
