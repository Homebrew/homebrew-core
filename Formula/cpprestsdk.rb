class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  url "https://github.com/Microsoft/cpprestsdk/archive/v2.10.1.tar.gz"
  sha256 "f38bc48e6fca969de794dcd65889df6563855cee5ff99742dafc6b2869976e71"

  head "https://github.com/Microsoft/cpprestsdk.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "558a95c46ce070de3f999d4c163d4246fbbcc5c614620131ffa856a3ddfdf288" => :high_sierra
    sha256 "e10956230ea249d761c6ddab5afb6da33a86b57dcb0e08fa8b9817be1f13299c" => :sierra
    sha256 "ec3c4db392f5b67505a17681aa1edff2b9037021fe60bd03358ff389ff436a4d" => :el_capitan
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
