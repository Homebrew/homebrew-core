class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "https://www.curlpp.org/"
  url "https://github.com/jpbarrette/curlpp/archive/v0.8.1.tar.gz"
  sha256 "97e3819bdcffc3e4047b6ac57ca14e04af85380bd93afe314bee9dd5c7f46a0a"

  bottle do
    cellar :any
    sha256 "8497c5ce375090d76c17a9197a07f2f55019ec2704e78208306a4e545e67bd46" => :catalina
    sha256 "4a8dc2ab4cb65ed349477a0cced49ea3e6ee19aa49983313f8221bf2da303bf4" => :mojave
    sha256 "0e5f9adbb17bd9e725fbe7ec11ada7a6d73e4a8ffb2448570b6ed16ed9fd2701" => :high_sierra
    sha256 "0d721493b94879cdf25162903fd5d10299b5d8386942efb0969c470afeef6b35" => :sierra
    sha256 "fd5c8375a1f4ef8aa20cfb740e8bac45c381ce6dbadc90f731e47b00c8a404b3" => :el_capitan
    sha256 "fd39edf63c0745f9d39a76f7b428eba285af313967ad4697d4fb08b705ee3eef" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
