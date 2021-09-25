class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.4.0.tar.gz"
  sha256 "1849f23bc436bfa83feaf719b9af887ac79a99064816b0a52fa88acde7e6b0b2"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ccd66c5297634d2d5197889bc77a67aa84c05619b8c1efbb3d1be87c6e57521f"
    sha256 cellar: :any,                 big_sur:       "a180d0bca0247d4d9d9f52209b41e865d867574228e28b42a54940fabfa090fb"
    sha256 cellar: :any,                 catalina:      "87b0b58907ced32ed0e936f41ed9f2e0eb96c65277d0bbcccee1b0c6cf2c168b"
    sha256 cellar: :any,                 mojave:        "84543de77265875fafa1b71a3d0e4f6b1794023f26cb6fa4314a0192cf2e1661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb2b2fbdbe13b883bf15777e61113adb4d11c1707069e7e34112a5cf7c180f66"
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
