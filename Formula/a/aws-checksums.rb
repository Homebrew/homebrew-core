class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "e624754cc57e0da28e643e89fc76bcc86cb0c359ead0745bae643f910b2bcfa7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36ab0fa0e338cadcf0de628d9b4ba8574cda3c5659d931808c4adea6db52c73f"
    sha256 cellar: :any,                 arm64_sequoia: "6acfec61a0c43ca7a69f0806c3962739c5be78ff5adb3d1fcfda479f62cb3437"
    sha256 cellar: :any,                 arm64_sonoma:  "490a11ee2fdd216a20feb6ca72148fbc7e15632eea6bb3ff1aa7e68991b1420b"
    sha256 cellar: :any,                 sonoma:        "bdd18e5f31dfc7c0b6e45682d1be727dc4158347213245a80c22073101d0be8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd37a5fe7d7f31be261c1fd56a78220833519062504c3bef79fbe0277a6cffe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d620c9de243bc3798f47401bd3fbdc27b543e0ece0d2aacb9001fb0bb764028"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    # Intel: https://github.com/awslabs/aws-checksums/commit/e03e976974d27491740c98f9132a38ee25fb27d0
    # ARM:   https://github.com/awslabs/aws-checksums/commit/d7005974347050a97b13285eb0108dd1e59cf2c4
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/checksums/crc.h>
      #include <aws/common/allocator.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        const size_t len = 3 * 1024 * 1024 * 1024ULL;
        const uint8_t *many_zeroes = aws_mem_calloc(allocator, len, sizeof(uint8_t));
        uint32_t result = aws_checksums_crc32_ex(many_zeroes, len, 0);
        aws_mem_release(allocator, (void *)many_zeroes);
        assert(0x480BBE37 == result);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-checksums",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
