class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.5.2.tar.gz"
  sha256 "4b4260132756d03be0c9350748d43125a8646873b88c27e551773f146c383822"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b59e109cda7179ed59444edccf6d0fd75917606af6398b8e0060649d0ee88cad"
    sha256 cellar: :any,                 arm64_big_sur:  "ae50a6e4de52d4753ad3774619d439fc8357ce87cd3804148c86e4939624633c"
    sha256 cellar: :any,                 monterey:       "d64dbff5e87f3493a358cf4e1335a886f6c96326b7dde064beb479081a289d16"
    sha256 cellar: :any,                 big_sur:        "ace366f4551d3dd96f1b8bac7a6bd5825c391909e8c1bdee95fbd529f69bf1dd"
    sha256 cellar: :any,                 catalina:       "37a05abb0fb7d412305f20eb74fb69a1d18fd0d25a05f67f921ad292f3e1f9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6fda242ce764b3d5bce71c7ead9bb2d02f65a142f5e4446b7b553783432aa4c"
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
