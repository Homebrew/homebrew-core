class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.1.21.tar.gz"
  sha256 "6409dcca5d47dc65fd67ba9b84ddc4a001c2108826b3c29109a983e56429bb77"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url "https://github.com/libplctag/libplctag/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "caf1b7bf99c00973b3426771060284094cc55733d092a68960b55b6572d4700b" => :big_sur
    sha256 "fb66dff912666fbe212d3f5074dd0fbab0853879aa476fa29f722f9368ae64b4" => :catalina
    sha256 "ec504d69a73485a044e657630103f0dade1ab23b5c421f5374c28ce54b6a61a9" => :mojave
    sha256 "25c5f9980dd56d9153e7e23168671cca5e5ee770aa762076820c7e307884a10a" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end
