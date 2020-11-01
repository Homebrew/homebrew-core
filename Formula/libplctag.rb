class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.19.tar.gz"
  sha256 "e1073ee36f8c13646f88ca2d1ca4f49904ad35d32692009550f1fdc1dbc84f95"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url "https://github.com/kyle-github/libplctag/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "90653b50dd3039cb1e865fc687b12129bc4d83a1d45110472cff740f8ddb8031" => :catalina
    sha256 "3318cef48c4e2f38972df3ed16244f7a81d41ab62c1679d72f519700145008ea" => :mojave
    sha256 "e0a96d697da987472f02724a04520913e39ba9c135869aaebb1852def888e7dc" => :high_sierra
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
