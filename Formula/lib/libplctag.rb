class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "f9a8c1092abaad40aa3330d402ac36028e88b4a50a93534b72b42716580c1b4e"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a8e21912b889421526cbe388601a67446783b78107f10f26bdce210f2c7a804"
    sha256 cellar: :any,                 arm64_ventura:  "04d67e008bf804a66b9331ad01f2af12d88f808024440471db677b00b3e2b29b"
    sha256 cellar: :any,                 arm64_monterey: "c2bd3674aa6430d1613d15e74ae4171ab24474a9cccbe61c294458b95d5d2c7e"
    sha256 cellar: :any,                 sonoma:         "82c931f491be52502cf856a9c2523b14e1f6ffea99e6aab391af02550e4ff20e"
    sha256 cellar: :any,                 ventura:        "552f29c50e5981ff80a1fcca503fbeebe3d896a90dd2e24be5c843d05034a8bf"
    sha256 cellar: :any,                 monterey:       "0e0e30ff9da68bf6d5e72df0cf3462eefe5b7d3feeb99f482b9f96b993c1e771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54adce2de479a93a16b27272ba9affa7154eeba80e46c0d2512e43076eb7f32"
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
