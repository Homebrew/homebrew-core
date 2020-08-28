class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.16.tar.gz"
  sha256 "3070e4f45af803bf49863ff9c8c4853eb031f19cee2f586bca04a64c35f8f3ce"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  bottle do
    cellar :any
    sha256 "f896ecbfb553eef7088c4aa25f4b87aadb4e6110fe71f75e32c938698710e15b" => :catalina
    sha256 "afbaf2be41d2242c994a74d7432f8ac018c7c2217838085d44ab218f74ae41ce" => :mojave
    sha256 "d63354a5e3e46fb7127b390c025cc21d6397ded7dadb6f47db567910631eed4c" => :high_sierra
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
