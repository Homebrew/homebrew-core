class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "http://www.curlpp.org"
  url "https://github.com/jpbarrette/curlpp/releases/download/v0.7.4/curlpp-0.7.4.tar.gz"
  sha256 "7e33934f4ce761ba293576c05247af4b79a7c8895c9829dc8792c5d75894e389"
  revision 1

  bottle do
    cellar :any
    sha256 "aad1ba504598a073ac81f56db02a6792ea7148e19918da8cfc368cf0a14fcf36" => :sierra
    sha256 "028b22d2b5fb6ccaef6b4f0c30195a9314d3b20ed3e403ad68587802b38e2aa9" => :el_capitan
    sha256 "9443ec4d10508f72a8b2fcc609c8e0c913ff145d0ae706fafd753e5ca76d2b2b" => :yosemite
  end

  depends_on "boost" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # https://github.com/jpbarrette/curlpp/issues/34
    # Workaround for #9315, replace CRLF with LF
    # This should be removed in the next release
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
