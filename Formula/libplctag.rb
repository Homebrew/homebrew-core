class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v1.6.3.tar.gz"
  sha256 "cad1d497d479ccfdfd92147a42b3fd431cadfe246a3c7cac63e2c7b6bcb67e2f"

  bottle do
    cellar :any
    sha256 "b525c3fe324e992683bffed84b70994e1d7173486699753f13047ba7a2d4485b" => :mojave
    sha256 "9aa1c20182ec17e0fb4cdc65d22bd1f742a62f13c1dbf0de57f1c8dd750b0b83" => :high_sierra
    sha256 "89d58532b7a32285a54729dd342af43b07c2c000711503c1adf44b1baf43de3c" => :sierra
    sha256 "387804acb86d5d50e0c5a22a2c83c6a83c83d6ab2966e7b2be00d2886ef9cf17" => :el_capitan
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
