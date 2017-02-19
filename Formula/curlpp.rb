class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "http://www.curlpp.org"
  url "https://github.com/jpbarrette/curlpp/archive/v0.8.0.tar.gz"
  sha256 "721271db0279fffeea94241650b6ceac3fdb767c0dcdf4f262859ab096066030"

  bottle do
    cellar :any
    sha256 "aad1ba504598a073ac81f56db02a6792ea7148e19918da8cfc368cf0a14fcf36" => :sierra
    sha256 "028b22d2b5fb6ccaef6b4f0c30195a9314d3b20ed3e403ad68587802b38e2aa9" => :el_capitan
    sha256 "9443ec4d10508f72a8b2fcc609c8e0c913ff145d0ae706fafd753e5ca76d2b2b" => :yosemite
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
