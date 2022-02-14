class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.5.0.tar.gz"
  sha256 "4a29097d7066769b059e0f3881ea23e68d7650ceb2aab2a6b278449823cba631"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1f5ab26a692dd5481a4382beed30a5f4b025a16500f21aad84fee52b1d0390a0"
    sha256 cellar: :any,                 arm64_big_sur:  "39010ea9a75362bde74fa705b2652fac446576149ab8ae48e21b80c7aaa0d988"
    sha256 cellar: :any,                 monterey:       "b26d81ea11cd0a425dbb9c6d100ffb09bee024d21af76ffcbb241c0da03e1957"
    sha256 cellar: :any,                 big_sur:        "27602f89e9ed26a8faae14104bdb001365e6759d6348a158c9f98f19dc941d22"
    sha256 cellar: :any,                 catalina:       "8669ea4e7a0ed4a427467a35fe670769d921e8430d06d6145c12b88f062fd04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734d1f637a09a1f0ddf2b46563c286076199dce145e58552e55914b83cd871be"
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
