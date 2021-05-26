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
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "d808e68204d6361e2d4325b8e6d2e15bf168064ce3ec6ea5fc99174368955995"
    sha256 cellar: :any, big_sur:       "8bddbc65a77417b3f103725275dfa0e6cc93bc26c5fa977cae35da6c97c572e3"
    sha256 cellar: :any, catalina:      "dfffba32c3e0d570170a33fe713b9899a08fbffeeccf14c3cb36138972a3b52a"
    sha256 cellar: :any, mojave:        "e8ab824fddb8ffcb2aea530d7124c9c7debd4592dce3b0f0e649d4d63bea587b"
    sha256 cellar: :any, high_sierra:   "528d7e5e52b8ff8cdcb9be22a884d8e8b49e08f9ef90d0b99362526e7117e9ee"
    sha256 cellar: :any, sierra:        "739033ca99d860134475385ee3fe9180366d36f51d0a08326b2c8bab4a84dbf8"
    sha256 cellar: :any, el_capitan:    "9bea031f090e48b33e9fa24b8dc5d0391b64dfdc93613ac6aed23c2643ad6e7b"
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
    system ENV.cc, "-L", lib, "-lswiftnav", "-o", "test", "test.c"
    system "./test"
  end
end
