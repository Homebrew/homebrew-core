class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "http://www.curlpp.org"
  url "https://github.com/jpbarrette/curlpp/releases/download/v0.7.4/curlpp-0.7.4.tar.gz"
  sha256 "7e33934f4ce761ba293576c05247af4b79a7c8895c9829dc8792c5d75894e389"
  revision 1

  bottle do
    cellar :any
    sha256 "4bd0e7d3471f3e9ed4717a2eb38a16224889deaef3ea61072d752aceec272d4c" => :sierra
    sha256 "d3605f5eb05b1f0151c2f3d40b5cba11aa18c783403856908ae9e758e401112e" => :el_capitan
    sha256 "e013c177a2f5dfb28d3f800ef015d9600e629d96897901604e21a697afec9ec1" => :yosemite
  end

  depends_on "boost" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Workaround for #9315, replace CRLF with LF
    system "sed", "-i.bak", "-e", "s/\r//g", "#{bin}/curlpp-config"
    rm "#{bin}/curlpp-config.bak"
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
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcurl", "-lcurlpp", "-o", "test"
    system "./test"
  end
end
