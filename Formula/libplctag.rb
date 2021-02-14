class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.3.0.tar.gz"
  sha256 "86141d5ab6d16ae892878177fdd747e9e44f2079a83c9b51dd9f93cd688f826a"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4056e0e3bb70d7ae73466b3cd4ebfa1263686488c02093d9971b3167fdc0fb2f"
    sha256 cellar: :any, big_sur:       "5b0524a3cbd9bb18363e1542575bb15d606d76af01c1951af31a1487281f9bb7"
    sha256 cellar: :any, catalina:      "5b4e7eb99c7e819414830fa910e6bdac55bf99bf5c9cb185e6d47ab058f8dfbb"
    sha256 cellar: :any, mojave:        "3a6adae63e7af57d0908e8a22420afb5dfb4288acc9806fa6d6d1573b64c25e3"
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
