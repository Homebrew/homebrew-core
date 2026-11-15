class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "b24d4896e8406ddff8080037936c86d539929369918265694bedcb887cbe602b"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9ce0e60dd5df71ef7cba4bdb9cd4bdecfa08a47557ff2c8fc7d262665de57942"
    sha256 cellar: :any, arm64_tahoe:       "9fce0dae86f6403d7ed0b01c302b143031c87dc66350240a8fdc3dae6cdc6761"
    sha256 cellar: :any, arm64_sequoia:     "f27ff2f02ea64ec556fe055173010e0d482e6306bf106d593c9e4a0255254a8a"
    sha256 cellar: :any, arm64_linux:       "834e56c60b2fc82b73da34b21398dc9e392304ccb0d9139d9111f9c235a4b80c"
    sha256 cellar: :any, x86_64_linux:      "69a90ac1aa866ca9b0967c51aaab8d56f065d643924c210389849eece5c8e245"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  deny_network_access!

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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
