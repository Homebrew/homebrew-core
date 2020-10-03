class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.19.tar.gz"
  sha256 "e1073ee36f8c13646f88ca2d1ca4f49904ad35d32692009550f1fdc1dbc84f95"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "0e7d03031e81f470c173eb9213c63c174362a1e36e639ef9457ec2c5d610646f" => :catalina
    sha256 "b4edcbc89600ec69b6377da5dd2fb7313102de51851dcf8f56aa4acdd3fd5a12" => :mojave
    sha256 "c8c448b5aca06c03b7b4be936b90b9daa4b88ed504ed322bdc63889cfdb4164b" => :high_sierra
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
