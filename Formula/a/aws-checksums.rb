class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "cb6509f75e42ee25c372a6d379e8582ce5179e5335183842e808f7d8abb0c314"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d445735de28c8a10112acf0aef35604333dd1e116178049cb14fac250cc2a8e"
    sha256 cellar: :any,                 arm64_sequoia: "51f9c37d851867716d37defe9144f5835fb6278ca1f35907e911a1d586bb0072"
    sha256 cellar: :any,                 arm64_sonoma:  "e24b9a1b71244f86bd5fa10251200429c07d8a059c0457f07adecab8ddb7f1ee"
    sha256 cellar: :any,                 sonoma:        "a61857ac1b1680a507dc293eafaec707cb2d9f3b39f4aa8526cf802f22d53b28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c915444ca9fc28a35b3b45d8af248c85af9e23b55d0f40e3dead889bd7f500e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f9b3e8cbcd098bf0ef110583df824360ad86e71dd9265904203872f59c763f"
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
