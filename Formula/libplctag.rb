class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.17.tar.gz"
  sha256 "7c64fca722856682d9e2db9ea1105d0d1ef29347aa36d45cb2af58cc4bb852e7"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "83a94db3e425bc86de5f315c307f4b7c98c5823849f074721f86888f989c3a72" => :catalina
    sha256 "c5aaf8decc5ba5ea38368c9d48f578409c4fa9c621194d2fbaf05bd012d296cf" => :mojave
    sha256 "3811f7f1d5a1b630426347b2936494abda7e40b280269d3955b3cc320b43b4e7" => :high_sierra
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
