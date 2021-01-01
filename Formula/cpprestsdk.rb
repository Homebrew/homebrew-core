class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      tag:      "2.10.17",
      revision: "41e7d0074b6cb5b22c89f835b4531d848ab66987"
  license "MIT"
  head "https://github.com/Microsoft/cpprestsdk.git", branch: "development"

  bottle do
    cellar :any
    sha256 "52968d001e986fdda32098fdb58cddb750f974e3472fd23c16424c1e3f6e5ff3" => :big_sur
    sha256 "0b7d717716ebc8393007599ed02f9a4f8b36eef1f3dd3d54d11b0966751a4f87" => :catalina
    sha256 "feeabdfce6c4a065961f37c38578d626a50f8e7a3939343a6ed037f535418a02" => :mojave
    sha256 "f98e8ff4c5b371ffe541eb1fefc13a178b02c07e6fab906fd206e6c833827dfa" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF", "Release", *std_cmake_args
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
