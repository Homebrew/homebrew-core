class Libswiftnav < Formula
  desc "C library implementing GNSS related functions and algorithms"
  homepage "https://github.com/swift-nav/libswiftnav"
  url "https://github.com/swift-nav/libswiftnav/archive/v2.4.2.tar.gz"
  sha256 "9dfe4ce4b4da28ffdb71acad261eef4dd98ad79daee4c1776e93b6f1765fccfa"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df259cd788dc4c271a2ae2296c17286163528eeb04cee8412fe450cf4a1549d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a25d1d7bab6a7c1fe2b53c6b22cd330abc8013a0c82764c96284e924dd9ef375"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e458c0d632aa814f63697a4a1fdd2a96d519f3846c9a5f7e04964df7cad26d"
    sha256 cellar: :any_skip_relocation, big_sur:        "39097a000739be8211214f46f80bb94709d3cc2784f7b4930d1b74107aeb87fc"
    sha256 cellar: :any_skip_relocation, catalina:       "48392c1a0f1d61146ec1cef2a3889b5c12355fea09360a7cbd2b9506f27259d0"
    sha256 cellar: :any_skip_relocation, mojave:         "18baf5f5cae22f042d5e08fff1f25a81f33950723560dfb72ad3bc989c1c258e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1648b6c5feaa7485011c42987bf2d6b7fbd2795130b83528d8a8960ef8f748"
  end

  depends_on "cmake" => :build

  # Check the `/cmake` directory for a given version tag
  # (e.g., https://github.com/swift-nav/libswiftnav/tree/v2.4.2/cmake)
  # to identify the referenced commit hash in the swift-nav/cmake repository.
  resource "swift-nav/cmake" do
    url "https://github.com/swift-nav/cmake/archive/fd8c86b87d2b18261691ef8db1f6fd9906911b82.tar.gz"
    sha256 "7b6995bcc97d001cfe5c4741a8fa3637bc4dc2c3460b908585aef5e7af268798"
  end

  def install
    (buildpath/"cmake/common").install resource("swift-nav/cmake")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <swiftnav/edc.h>

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
    system ENV.cc, "test.c", "-L", lib, "-lswiftnav", "-o", "test"
    system "./test"
  end
end
