class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "http://www.curlpp.org"
  url "https://github.com/jpbarrette/curlpp/archive/v0.8.1.tar.gz"
  sha256 "97e3819bdcffc3e4047b6ac57ca14e04af85380bd93afe314bee9dd5c7f46a0a"

  bottle do
    cellar :any
    sha256 "5571593d8b5c6c6253855ab65a8cd7eddd71c4cbf2f8c8cbc53b65ddd511ac37" => :sierra
    sha256 "ff5e97d9d4e52d7ab4913ae56112687519e147926bbb56a08ea7f4def437e34a" => :el_capitan
    sha256 "7fbfb4fb3107e7ad6d41dac32c6216e71d430cbcadfb41ee0245604342a2d060" => :yosemite
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <curlpp/cURLpp.hpp>
      #include <curlpp/Easy.hpp>
      #include <curlpp/Options.hpp>
      #include <curlpp/Exception.hpp>

      int main() {
        try {
          curlpp::Cleanup myCleanup;
          curlpp::Easy myHandle;
          myHandle.setOpt(new curlpp::options::Url("https://google.com"));
          myHandle.perform();
        } catch (curlpp::RuntimeError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        } catch (curlpp::LogicError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        }

        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lcurlpp", "-lcurl"
    system "./test"
  end
end
