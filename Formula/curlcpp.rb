class Curlcpp < Formula
  desc "Object oriented C++ wrapper for CURL (libcurl)"
  homepage "https://josephp91.github.io/curlcpp"
  url "https://github.com/JosephP91/curlcpp/archive/refs/tags/2.1.tar.gz"
  sha256 "4640806cdb1aad5328fd38dfbfb40817c64d17e9c7b5176f6bf297a98c6e309c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05894a21256673beac0596b6e958f59db75ec36da02558bd7c041fb54c6f8697"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bb7fe5ac0dff7a50895ac53f4d900fb3749359165793ecfcbb52097b8e61bdf"
    sha256 cellar: :any_skip_relocation, monterey:       "bddaeedc877b345c7dfe485cf05f454bcf79fa8b590e49ac1327e50f19de2a5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9aaa35833c5ff7abfdf14754de9bff898830eba9937bca20bf008daa834d8fc"
    sha256 cellar: :any_skip_relocation, catalina:       "93f35668b6706082619d7334120db30d1a03bd8120cb30befca411af1370eac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aeae5e349d81fb58b1b83095c62a8eef638e8aac24711fcd73ed8f2987aa4ca"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
