class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "96acfea882c06acd5571c845e4968892d6ffc0fae81b31a0b1565100049743b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e802dc8eac8372e653773a877ff36975a07798f2ae51d0a3b2a899e349b633d"
    sha256 cellar: :any,                 arm64_sonoma:  "067ba18a6a9c5653525345a2cc1c1bf05beefdb677255850fb4fe29f5467cae7"
    sha256 cellar: :any,                 arm64_ventura: "5f0aabfecca0f8c781d8ef1f13ac16ff833d9faf3cab49ff8bbe3b8cd937de3b"
    sha256 cellar: :any,                 sonoma:        "d1d9d6c6b6e04ec433b22103bcab8170ba4f4129692c1d19aa7d99824e79d051"
    sha256 cellar: :any,                 ventura:       "22d8baee39eb4a1ce7094d73ee636c7662aa6f0a9d814e5c11282a286f708a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613c246f48282a253b59f8fbccf60497d656e794e98ab9e882f783e872b877f7"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
