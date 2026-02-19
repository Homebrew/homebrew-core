class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.14.tar.gz"
  sha256 "b58aaae10efd99bec820cf1f66ff39cced5b9b31bd4f4e0695811ea33b469c10"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dceb68f387f52e6931dc3e2b822bf7cdb1fa465a20ab6db4fd219a123a851bae"
    sha256 cellar: :any,                 arm64_sequoia: "d56001ff1d7199ae10cecc34235132b4d7a6ee6d833edd6cb0b737a03a4654f9"
    sha256 cellar: :any,                 arm64_sonoma:  "68d62103d8394cf7f7b13ac0068393ae6f1c14d39874ca7d1924f7e7cbdf3f00"
    sha256 cellar: :any,                 sonoma:        "838d47ae8ed445678848882754e999aa5ba34b78a24c5d0f3fe766f444676118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02526c74c4617eefb4f2282a73a7d35565f68b515250f05203c83ab3a9507fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa5fc29d194fade63f7de33f1842a1a79b2ff36899953f9a951e4a46bcd42ef"
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
