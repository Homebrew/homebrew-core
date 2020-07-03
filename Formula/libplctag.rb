class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.9.tar.gz"
  sha256 "39705326f4680bec20c0013858956b5a8dd558a2b4d81725f7849d59a99aeac7"

  bottle do
    cellar :any
    sha256 "43dc8fbd35e0b53ee09b07063350da4ba5c08329d5fbe53f4088655e9764d0ff" => :catalina
    sha256 "72e728b5beae0fc78d5b169bd7f7b5e22a8794f4cde456acaf62ba7b2db052b4" => :mojave
    sha256 "dc32cb3cabf58e7d9b1c21b78882fe177c21ef79fc712cf3899dcdcb0ce995cc" => :high_sierra
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
