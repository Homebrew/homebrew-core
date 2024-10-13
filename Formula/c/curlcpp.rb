class Curlcpp < Formula
  desc "Object oriented C++ wrapper for CURL (libcurl)"
  homepage "https://josephp91.github.io/curlcpp"
  url "https://github.com/JosephP91/curlcpp/archive/refs/tags/3.1.tar.gz"
  sha256 "ba7aeed9fde9e5081936fbe08f7a584e452f9ac1199e5fabffbb3cfc95e85f4b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "02d6013f6cebe3e32f938baf215bc25a97b6b20b04e7639f59f360f81c0984a1"
    sha256 cellar: :any,                 arm64_sonoma:   "a7d90c04040339eb2d284bb2c1510806df36bc0fa37ddd8445db1dd63e9e5016"
    sha256 cellar: :any,                 arm64_ventura:  "c3f9991c295224065b7df591bf5f28c1ec9247e16ebfa3318d20d99fcd20aa62"
    sha256 cellar: :any,                 arm64_monterey: "0e9dad877d6c11ed3243c0463f69daaeabe74dcd54ccf80dad016d85c5951546"
    sha256 cellar: :any,                 arm64_big_sur:  "5337cf2331b855265be23c9ad2209977c07ab6acf9ca7c808e14b58494923407"
    sha256 cellar: :any,                 sonoma:         "786f28cab6cc4ef524212c85d133968158e692572148a1b4f06433c836ecabf6"
    sha256 cellar: :any,                 ventura:        "ff1362a719032031c6dac022c9ccd060533a0b19d8dd5de454d0713461f8d24a"
    sha256 cellar: :any,                 monterey:       "69efcd43355ab8ba5ed151d52462c1b87541f898d0f02046bfcf2d9da6e720cd"
    sha256 cellar: :any,                 big_sur:        "05ea45b1b2fce091147574dab246b00275c2b97a6554c5e4071f66777c018b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fab29cd023b9fa39d098dd1ab0f56bdc0709e68f2855596b48b3012c06bc9f6"
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
