class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  url "https://github.com/Microsoft/cpprestsdk/archive/v2.10.6.tar.gz"
  sha256 "5fecccc779b077f18acf0f7601b19b39c3da963498ed5b10bb2700dccfe66c5a"
  head "https://github.com/Microsoft/cpprestsdk.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "70aa8095ca1b1ad92ca77122602d1fc999b523e9cb97f680a056328620c571fe" => :mojave
    sha256 "9103ac596b82312771f1b1cd2b0a7dfc3cf0c2dfe3d51eb9642d9488a51cc3be" => :high_sierra
    sha256 "9172c16e95e799434c9336b7c6d87893dd507e7b7682e9009c8bc59eaabf47f3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl"

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
