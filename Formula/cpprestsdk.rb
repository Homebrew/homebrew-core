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
    sha256 cellar: :any, arm64_big_sur: "ac66587bc353b3358ff11606ca3952fa57f7dc57a5f59414ed8bfa62e90ff858"
    sha256 cellar: :any, big_sur:       "c65b7f42fed4091750be219a60774854de46903c74ef99def1b73f905bb0728f"
    sha256 cellar: :any, catalina:      "f89613fba00d0feaa3e55508f3fb122dc8f4126b679e55c22fd228ed44d0c1c4"
    sha256 cellar: :any, mojave:        "6805fd31638651ef090d68e07cdea155d70b23365828cd1adbfd60fc132eedc3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "openssl@1.1"

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
        web::http::client::http_client client(U("https://github.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    EOS
    flags = ["-stdlib=libc++", "-std=c++11", "-I#{include}",
             "-I#{Formula["boost"].include}",
             "-I#{Formula["openssl@1.1"].include}", "-L#{lib}",
             "-L#{Formula["openssl@1.1"].lib}", "-L#{Formula["boost"].lib}",
             "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono",
             "-lboost_thread-mt", "-lboost_system-mt", "-lboost_regex",
             "-lboost_filesystem", "-lcpprest"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_cpprest", "test.cc", *flags
    system "./test_cpprest"
  end
end
