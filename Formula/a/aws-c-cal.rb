class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://github.com/awslabs/aws-c-cal/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "516ff370a45bfc49fd6d34a9bd2b1b3e753221046a9e2fbd117341d6f9d39edc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "805db23f20f56165982128815270e0d3d7569586ffded08cf68a00963b8ee28b"
    sha256 cellar: :any,                 arm64_sonoma:  "be94a8aaeebd6b19862d159fb337ab434c7c941214b80ee689b7106c75aee5ae"
    sha256 cellar: :any,                 arm64_ventura: "52ea1d565cba9ec99425c7ade3467106ce3d43738b215fa71763b3a78bfa7a3c"
    sha256 cellar: :any,                 sonoma:        "fa872ac3994aaf19acf3a0f35a2da052f28e9ec756b727ad13e981024430e133"
    sha256 cellar: :any,                 ventura:       "c9e9057029659df7cd6fa49d928de060e4d7388eeeed78c4dcbab3f86677ffec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "241f6e37d440e972c7cd08c5bd447fdc1e587fc24669fabec0107f4c458f2ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6a9a426ca086dc2bddd15b51b7d3fddcf23142b9854a00711bdd07290918e00"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    args << "-DUSE_OPENSSL=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/cal/cal.h>
      #include <aws/cal/hash.h>
      #include <aws/common/allocator.h>
      #include <aws/common/byte_buf.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_cal_library_init(allocator);

        struct aws_hash *hash = aws_sha256_new(allocator);
        assert(NULL != hash);
        struct aws_byte_cursor input = aws_byte_cursor_from_c_str("a");

        for (size_t i = 0; i < 1000000; ++i) {
          assert(AWS_OP_SUCCESS == aws_hash_update(hash, &input));
        }

        uint8_t output[AWS_SHA256_LEN] = {0};
        struct aws_byte_buf output_buf = aws_byte_buf_from_array(output, sizeof(output));
        output_buf.len = 0;
        assert(AWS_OP_SUCCESS == aws_hash_finalize(hash, &output_buf, 0));

        uint8_t expected[] = {
          0xcd, 0xc7, 0x6e, 0x5c, 0x99, 0x14, 0xfb, 0x92, 0x81, 0xa1, 0xc7, 0xe2, 0x84, 0xd7, 0x3e, 0x67,
          0xf1, 0x80, 0x9a, 0x48, 0xa4, 0x97, 0x20, 0x0e, 0x04, 0x6d, 0x39, 0xcc, 0xc7, 0x11, 0x2c, 0xd0,
        };
        struct aws_byte_cursor expected_buf = aws_byte_cursor_from_array(expected, sizeof(expected));
        assert(expected_buf.len == output_buf.len);
        for (size_t i = 0; i < expected_buf.len; ++i) {
          assert(expected_buf.ptr[i] == output_buf.buffer[i]);
        }

        aws_hash_destroy(hash);
        aws_cal_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-cal",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
