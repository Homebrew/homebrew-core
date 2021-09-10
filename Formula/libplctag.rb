class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.3.7.tar.gz"
  sha256 "7281ce0716d235d51437c1dcdc479896372e5065d0db4e5a761da3c29445057a"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "955d7027e9868669dc8af857c7ac3bd85dd8ef90eb7c49b7cdcdad331707748f"
    sha256 cellar: :any,                 big_sur:       "d432b6381f50957fd2722ad17e4f201db4802f1177e0afc4f7b39d143a8d4cc4"
    sha256 cellar: :any,                 catalina:      "cdbb0f6e478e600f11a3d5eab2f8a4e7329a16457df363ba64dd275322c1a903"
    sha256 cellar: :any,                 mojave:        "e0fec1b3e35e298313e3fb675dd263322965b4d176b42a35e4ea4aab757d7afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0fd9e1a2b1f3194cf036633466aa31fd2ab15b3d321829a49c4e2b3e095877"
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
