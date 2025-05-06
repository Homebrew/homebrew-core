class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "0f2983e024c9ca8dd7e956258f0b99d64cc8c37aa0cf3eb75350e1edca00841f"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "541435d2df4cf296f05adb46a6f44c5cc5cd4181107cedd641c7a98e3c137339"
    sha256 cellar: :any,                 arm64_sonoma:  "3c97113bf7d6f7655911edd5c74793d6e555d4b26016414356f91fe6d9412792"
    sha256 cellar: :any,                 arm64_ventura: "67cee16a6e8835ff6a153a0f0724e5d508171f9d901b394f3ba3f6689417701e"
    sha256 cellar: :any,                 sonoma:        "b3dd6661167b714560164a61b32c1e8960fe43ec7f9cfb5e7bdcad90be61de2e"
    sha256 cellar: :any,                 ventura:       "c90369c966d930837a140d98f7fa243b411b29e5d39218ef6d9f0c2395e562bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9531ccb144fe7c05d348c227f23ffec80b30d755e5adc9f9f43576dfceb3d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc1f12a2e4f5b6fa68c9925b3d0238a4b66e19405a9c72b043c87a0df9636dab"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end
