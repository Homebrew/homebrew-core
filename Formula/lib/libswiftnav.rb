class Libswiftnav < Formula
  desc "C library implementing GNSS related functions and algorithms"
  homepage "https://github.com/swift-nav/libswiftnav"
  url "https://github.com/swift-nav/libswiftnav/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "9dfe4ce4b4da28ffdb71acad261eef4dd98ad79daee4c1776e93b6f1765fccfa"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "33463f96c4b94f36447f45dcd3fb5c039e374a1ccbf8e3ca7b5f8cddf2627d68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1ddd75cc7bfb08208ea88e3bbc3f3d5549c9c72511dc9378ab31101d50591c48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0596c6cfaf45b62cd39b4fc4fc7f01b8b786914471e1b534be2f54c7f64921b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e3b556518c6860f34af3d1a2e4e1c3c134d089f6b86b53f8317fa8eff9f99b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df259cd788dc4c271a2ae2296c17286163528eeb04cee8412fe450cf4a1549d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a25d1d7bab6a7c1fe2b53c6b22cd330abc8013a0c82764c96284e924dd9ef375"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d1816993437aea825dad690affb239660bed9a4e61b04536bc7cf6758c5a5e1"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f845cbb35711aabf115910c838fbc2c5fedef78728ae695e28e5c038425885"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e458c0d632aa814f63697a4a1fdd2a96d519f3846c9a5f7e04964df7cad26d"
    sha256 cellar: :any_skip_relocation, big_sur:        "39097a000739be8211214f46f80bb94709d3cc2784f7b4930d1b74107aeb87fc"
    sha256 cellar: :any_skip_relocation, catalina:       "48392c1a0f1d61146ec1cef2a3889b5c12355fea09360a7cbd2b9506f27259d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7767ebdfd1dd030cc3ddb4bce85f6d113bb5b7c122e859950c264fc800054221"
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

    # Work around CMake compatibility issue. Remove with next release.
    inreplace "CMakeLists.txt", "cmake_minimum_required(VERSION 3.0)",
                                "cmake_minimum_required(VERSION 3.13)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L", lib, "-lswiftnav", "-o", "test"
    system "./test"
  end
end
