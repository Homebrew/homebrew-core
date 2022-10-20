class Curlcpp < Formula
  desc "Object oriented C++ wrapper for CURL (libcurl)"
  homepage "https://josephp91.github.io/curlcpp"
  url "https://github.com/JosephP91/curlcpp/archive/refs/tags/2.0.tar.gz"
  sha256 "818e6d0cc027be6f0bd65dfed142c64a97aed1f0ae8e9f1490d19e4375734304"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "37b2a88d790badde11d542cb0bc659394ce20ee105b1a594ee20dd93cec53874"
    sha256 cellar: :any,                 arm64_big_sur:  "38ac3e1bfed36e52a7efc40772dec21a1c417f850bffb320da78009520dcd409"
    sha256 cellar: :any,                 monterey:       "5b52f0e17d2c6ef7c8e53a038854f331b6a77cc2f4462b6e5b624c59eb27368c"
    sha256 cellar: :any,                 big_sur:        "6fc716d9475e43222ae78511cc50c8b681fe146aa0628deb8da4abe947e93dc8"
    sha256 cellar: :any,                 catalina:       "0cb646d8b486010a1503e302fa15c8178807d4d6319b4786a6428f855f1a63aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7a017f66ccb397d33d10c59c358ccf1c84a4b56ff4a27cdf9a92427dceab86"
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
