class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v1.5.9.tar.gz"
  sha256 "65461ac674fca9ca2e296e0011f8e8290afcdfbfe6b26de607b64c384fb7bbce"

  bottle do
    cellar :any
    sha256 "3afd031bd8fce43bfae5ff09e9eb75a081eeadd70aa90e2d9d33cf40938647cd" => :high_sierra
    sha256 "b984b37f0c37f588fc2d446e2194033dc1d7e1d7c56d8200c9b1a2550eab3ac4" => :sierra
    sha256 "8014504237e0d1dc3190e5ee4a2bfd4ef8be84f19ae9e13483ef844c2f84860b" => :el_capitan
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
        plc_tag tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray");
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lplctag", "-o", "test"
    system "./test"
  end
end
