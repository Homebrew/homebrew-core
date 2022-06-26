class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      tag:      "2.10.18",
      revision: "122d09549201da5383321d870bed45ecb9e168c5"
  license "MIT"
  head "https://github.com/Microsoft/cpprestsdk.git", branch: "development"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e19ac91eefbd583d66f0b0fe37b6d416bbb650570546804948eca22c63900e5f"
    sha256 cellar: :any,                 arm64_big_sur:  "ac66587bc353b3358ff11606ca3952fa57f7dc57a5f59414ed8bfa62e90ff858"
    sha256 cellar: :any,                 monterey:       "32c6be3ba57c08c2832f91a6003464acef7d21427b9ac8a817580faa2df9e998"
    sha256 cellar: :any,                 big_sur:        "c65b7f42fed4091750be219a60774854de46903c74ef99def1b73f905bb0728f"
    sha256 cellar: :any,                 catalina:       "f89613fba00d0feaa3e55508f3fb122dc8f4126b679e55c22fd228ed44d0c1c4"
    sha256 cellar: :any,                 mojave:         "6805fd31638651ef090d68e07cdea155d70b23365828cd1adbfd60fc132eedc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50ae9413de519a390c5864972bd19432a203cdea200158e1110671e969385c1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"]}.opt_prefix",
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
                    "-I#{Formula["boost"].include}", "-I#{Formula["openssl@1.1"].include}", "-I#{include}",
                    "-L#{Formula["boost"].lib}", "-L#{Formula["openssl@1.1"].lib}", "-L#{lib}",
                    "-lssl", "-lcrypto", "-lboost_random-mt", "-lboost_chrono-mt", "-lboost_thread-mt",
                    "-lboost_system-mt", "-lboost_filesystem-mt", "-lcpprest",
                    "-o", "test_cpprest"
    assert_match "<title>Example Domain</title>", shell_output("./test_cpprest")
  end
end
