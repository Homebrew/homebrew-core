class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "178e8398d98111f29150f7813a70c20ad97ab30be0de02525440355fe84ccb1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "651646b3d9106d84eab329a87a558d55654de9141315ad1fe0f1bc01253ffade"
    sha256 cellar: :any,                 arm64_sequoia: "b109e8f4cf42b41d08ec355d3b2abf4e55cef2451ff308130815c026556982e7"
    sha256 cellar: :any,                 arm64_sonoma:  "d162d62888aa8aae8ddcab6d6639395c452b930b6351e5fbfc32bac1a07d9465"
    sha256 cellar: :any,                 arm64_ventura: "411782961b2ae15dbafeab24cc77f22ef3aafc58ae1d12eafd3655fee97e588f"
    sha256 cellar: :any,                 sonoma:        "5813da053800b6fff4cb6e7b091b0a24991226702ad8a2e1193d9e90a0d60285"
    sha256 cellar: :any,                 ventura:       "658f25960e74c00710c06ff1328678036b460f6e32f974ee3b1056f413628556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10aed55de1097e6ce6fdbfc40f93d8b148a7ede46eea8acb2b0c068d64136dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef7f2358c7998d4da746e253e360b1665290a5893dc79344d44dbfe8d334abb"
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
