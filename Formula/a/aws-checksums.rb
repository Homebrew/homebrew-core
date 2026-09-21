class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6c058812f5b537ce58eac1e529f441ff387a652ea62cbe9b844f9188339221b1"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ce7b44604d62aaddd66eb329fe763795e7ebc7d2038da936cd51e0939bdcb005"
    sha256 cellar: :any, arm64_tahoe:       "93cd0e5e990300033e5bc17facaf0594d9c2340d03848b3a0ad902737ff30e3d"
    sha256 cellar: :any, arm64_sequoia:     "8047f945f26b39339e1e42cf913b316841acc8aa8b8de4d2b6ff0a0387094c4d"
    sha256 cellar: :any, arm64_sonoma:      "fc90f1d09f6059255be7eab027ccc62779c28c5ecfda9b5453bbcc44fd12d4f6"
    sha256 cellar: :any, arm64_linux:       "3bc35f4ed2476aa9557d0f846ce78a1277253b1946568f3af585b2fcba37e31a"
    sha256 cellar: :any, x86_64_linux:      "f616469e31ccb7a85775295452d68cc8d8d9e286dd00eec602371f189aa93789"
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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
