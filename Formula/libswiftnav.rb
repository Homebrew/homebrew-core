class Libswiftnav < Formula
  desc "C library implementing GNSS related functions and algorithms."
  homepage "https://github.com/swift-nav/libswiftnav"
  url "https://github.com/swift-nav/libswiftnav/archive/v0.21.tar.gz"
  sha256 "99e7ac3f190d76b2c1ceb17dae76d24b86d1a71501db4f6a49759539bb393756"

  bottle do
    cellar :any
    sha256 "ec5142cb510d648fbc57b8e3acb7ff4925d720a305c18efd34511aae16aeb066" => :high_sierra
    sha256 "3f0e52c5a7be06dbcf140870af9ee3f74520d78a51104973d8279793f7919d1d" => :sierra
    sha256 "c5730d05abf427a9213faf36dd13517771bf1905f8df01619932c173c581e550" => :el_capitan
    sha256 "96e3a1e2e74ddce115e6ea88c389aa970c9acabaf6e75b3322ac0f23858fec85" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <libswiftnav/edc.h>

      const u8 *test_data = (u8*)"123456789";

      int main() {
        u32 crc;

        crc = crc24q(test_data, 9, 0xB704CE);
        if (crc != 0x21CF02) {
          printf("libswiftnav CRC quick test failed: CRC of \\"123456789\\" with init value 0xB704CE should be 0x21CF02, not 0x%06X\\n", crc);
          exit(1);
        } else {
          printf("libswiftnav CRC quick test successful, CRC = 0x21CF02\\n");
          exit(0);
        }
      }
    EOS
    system ENV.cc, "-L", lib, "-lswiftnav", "-o", "test", "test.c"
    system "./test"
  end
end
