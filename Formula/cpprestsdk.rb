class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      tag:      "2.10.17",
      revision: "41e7d0074b6cb5b22c89f835b4531d848ab66987"
  license "MIT"
  revision 1
  head "https://github.com/Microsoft/cpprestsdk.git", branch: "development"

  bottle do
    cellar :any
    sha256 "c309b77276176ea9fea0378fe707b234d5710292a064648d7572cd6e9859fb14" => :big_sur
    sha256 "7072462b2649c97ab3cea7ffa5506588d6f5099ad916c431bb096842a1ef7a32" => :arm64_big_sur
    sha256 "804a90dd19fd6cadc63830629cab9dff350219022b127303801920a9a76103d8" => :catalina
    sha256 "aee49d4c1082f6ab0d2297b6e6066f1b0c53b2bd970b2ce3e68262ad5327a7a2" => :mojave
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
