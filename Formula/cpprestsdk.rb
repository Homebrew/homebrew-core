class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  url "https://github.com/Microsoft/cpprestsdk/archive/v2.10.3.tar.gz"
  sha256 "5bf66469ca2eaaf2d2ea8ff42e154cc18036877173766f37f018758ba2cfd0fa"
  head "https://github.com/Microsoft/cpprestsdk.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "d14bed2a2b49d91649d9fc8aa9708b1dc37b3c5b2b8bffcbdda79c2df8542319" => :high_sierra
    sha256 "f72554353c248a4f479be76e8382fef549c9abb2690445adb6bcb49d8f867bd1" => :sierra
    sha256 "53b4cdfd9b0b964a1803920d02ae066a4ddb2be58e68477d34906ba44048e52a" => :el_capitan
  end

  depends_on "boost"
  depends_on "openssl"
  depends_on "cmake" => :build

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
             "-I#{Formula["openssl"].include}", "-L#{lib}",
             "-L#{Formula["openssl"].lib}", "-L#{Formula["boost"].lib}",
             "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono",
             "-lboost_thread-mt", "-lboost_system-mt", "-lboost_regex",
             "-lboost_filesystem", "-lcpprest"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_cpprest", "test.cc", *flags
    system "./test_cpprest"
  end
end
