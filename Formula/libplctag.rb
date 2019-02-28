class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v1.6.3.tar.gz"
  sha256 "cad1d497d479ccfdfd92147a42b3fd431cadfe246a3c7cac63e2c7b6bcb67e2f"

  bottle do
    cellar :any
    sha256 "16f8ab350a1c91f79f72ded512c4c4255aceae2163f90e6c54740edec4c353fd" => :mojave
    sha256 "76aef0cc92daeac867f30286c24384827aff6bb17866a5381e05dcbe43f0c8d3" => :high_sierra
    sha256 "00ccfb0c08bf8f5b351ac26b116ef108b219cdec64f2ff0bd77b9b90ad8f3f8e" => :sierra
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
    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end
