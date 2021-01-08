class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.1.22.tar.gz"
  sha256 "0c6b0ffb5a625c59873ca0da76b11fa52b6e83ec7fe09a2ce7fc4387878d668b"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "c2ec604baf5a893508ae8a45fc2af74efd0abb22aaba2119743e00c8c8685858" => :big_sur
    sha256 "ec91e0e4c5565138b4faf0f2e9b36f00c606c678a12e112542648793c15dcfa4" => :arm64_big_sur
    sha256 "d45af9651866466b70b2c5c6479d7681d216230ef6b7c892c0450edeedb5714c" => :catalina
    sha256 "56a3926222b479954123f5e922d09d0ec71817f7afbbfcffac57a31daa2eee29" => :mojave
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
