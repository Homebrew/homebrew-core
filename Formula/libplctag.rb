class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.11.tar.gz"
  sha256 "3b26054cf24f17ce8257172aee07f9f8a85dccfa061869dfab1924e7002887e1"
  license "LGPL-2.0"

  bottle do
    cellar :any
    sha256 "e7ec3a0ac838e6129951d86e8b44b3d5b2073573e0904069ccb3a3a69a9d5085" => :catalina
    sha256 "bc6689ac25d424e181cfae19f16b39d6982f15427d4c41c85fedbfce8d2b269f" => :mojave
    sha256 "a1750c6395f496fd27783a5de308702ac21a2e5eda5a027d80b39efdfc276f7f" => :high_sierra
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
