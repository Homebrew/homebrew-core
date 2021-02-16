class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.3.2.tar.gz"
  sha256 "b282118f8dcee692af2b38e1d14aa58e12ce90ce30606000b5318702f7d19971"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "961c3b0c349aae9330821e9e8e978e7fd06aa37a9866168e747b4d74ea820263"
    sha256 cellar: :any, big_sur:       "575776c09c8b5ddaef92b2f003e191bae4ae396cf1c9f4d4ad74098e48ebbff9"
    sha256 cellar: :any, catalina:      "980f85c89872820edcea52b0943d5e7930d60eb333c0965f9a0c848e073ff360"
    sha256 cellar: :any, mojave:        "002e7ddb3515e24afbadc18d1ea3eb603590b5d623536912d4fdcc2d0554f5a7"
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
