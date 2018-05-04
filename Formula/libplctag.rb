class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v1.5.8.tar.gz"
  sha256 "03847aeb4bdbfad255e62feff029b9b0c81758e66b840237023243b1c1b764ec"

  bottle do
    cellar :any
    sha256 "a784c2b1d50c673cf3557e774f78b44bd1968a162f715afeca9b31e27f136d5c" => :high_sierra
    sha256 "76e29f82f14a9f0a7b08cae7a8c13bdbbf46a8bf947ea1a2c7b1b7eea2a25165" => :sierra
    sha256 "13703497dc39ded95c332fd2eb4cae4aa34bb0ee77c7027de1b37b0ec276052b" => :el_capitan
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
