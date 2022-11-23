class Curlcpp < Formula
  desc "Object oriented C++ wrapper for CURL (libcurl)"
  homepage "https://josephp91.github.io/curlcpp"
  url "https://github.com/JosephP91/curlcpp/archive/refs/tags/2.1.tar.gz"
  sha256 "4640806cdb1aad5328fd38dfbfb40817c64d17e9c7b5176f6bf297a98c6e309c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d0cf01ddde03c507a2bd9cd73435ddb94b40af0e2e3ae0d5f7f9703587d42075"
    sha256 cellar: :any,                 arm64_monterey: "e70c7484aed5b013bbc49a864f87c2d40dd9e676af6d3dc8707ffa5f16dd4939"
    sha256 cellar: :any,                 arm64_big_sur:  "4952d85cefca84d9560ede7c578e6ce82a154fdd04ac687df176828ed70e2f74"
    sha256 cellar: :any,                 ventura:        "fe4d6d92c15c7850c6fdb14f2bbb1074dcfb8ce3fa126a0c717672fab75be065"
    sha256 cellar: :any,                 monterey:       "923737339644b84caf3ac29496322122a4bfd9832917043edb573449e8a1a4e9"
    sha256 cellar: :any,                 big_sur:        "8aa270f7d78106ccbc7bda731a686bd8eccacc9b39869994d591c17b133a1620"
    sha256 cellar: :any,                 catalina:       "9906724ad57ab32ba2eae45684a25feb1ce06696ca202563326a9da68fcc5647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4de367f61cc68ad0ed5f74f2504d5ba6097d30b89258f69a6bfdfd9b05b192"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=SHARED"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <ostream>

      #include "curlcpp/curl_easy.h"
      #include "curlcpp/curl_form.h"
      #include "curlcpp/curl_ios.h"
      #include "curlcpp/curl_exception.h"

      using std::cout;
      using std::endl;
      using std::ostringstream;

      using curl::curl_easy;
      using curl::curl_ios;
      using curl::curl_easy_exception;
      using curl::curlcpp_traceback;

      int main() {
          // Create a stringstream object
          ostringstream str;
          // Create a curl_ios object, passing the stream object.
          curl_ios<ostringstream> writer(str);

          // Pass the writer to the easy constructor and watch the content returned in that variable!
          curl_easy easy(writer);
          easy.add<CURLOPT_URL>("https://google.com");
          easy.add<CURLOPT_FOLLOWLOCATION>(1L);

          try {
              easy.perform();
          } catch (curl_easy_exception &error) {
              // If you want to print the last error.
              std::cerr<<error.what()<<std::endl;

              // If you want to print the entire error stack you can do
              error.print_traceback();
          }
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lcurlcpp", "-lcurl", "-o", "test"
    system "./test"
  end
end
