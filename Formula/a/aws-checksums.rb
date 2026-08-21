class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "6917e18b8d6079c02f36478ac59174eb3c47dc3bf040ea63bd93d127837f873f"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1b8626139773ebbe0958e66cad6a09ed8578ef710a317f5ad1897ba59223ccf2"
    sha256 cellar: :any, arm64_sequoia: "251bf75fa42c8e9acb0b2b31cb7e8f7e0d15c8eece127964abb95587410f341a"
    sha256 cellar: :any, arm64_sonoma:  "d18aa681ef0221eef59e95907480e98736eea1906806fac4a84f2476c3223fb2"
    sha256 cellar: :any, sonoma:        "bc7b5f31ee89f59b3de05bf416e793adccb0f5197d8061cfe0d975f5e1f8fd69"
    sha256 cellar: :any, arm64_linux:   "abda43c6a050cfbe4fb0304fb2e55bb31993915e14c71d39fc167ec6caba7c07"
    sha256 cellar: :any, x86_64_linux:  "a0d4f09f42bb244faffbf620985df9bc2fbec9b68930180bb319444e3bd980b2"
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
