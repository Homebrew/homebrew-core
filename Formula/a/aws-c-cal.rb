class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://github.com/awslabs/aws-c-cal/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "9c6d424d206dd7822aa44fa39ce31575dcbaa83133620abdac8e56e4cea9667c"
  license "Apache-2.0"
  revision 1
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4fe05862beb90cc62de65c114d28303e16b49784291033388deed1f962080e16"
    sha256 cellar: :any, arm64_tahoe:       "b07ed49e2e61f65a1cf416669387dc582c6dfa254c639841220bac9be9e2ae8a"
    sha256 cellar: :any, arm64_sequoia:     "f9aabf2cda22318de8d70e0eed3239885f7e9d8bc335096226ea88dd12bfa9e8"
    sha256 cellar: :any, arm64_linux:       "69bb772ab91ce811dbe8a182ec4dc64ff5e8cdddd4731146f0a9e8812b29c12e"
    sha256 cellar: :any, x86_64_linux:      "2671dffb067fe8702ee66e276c3419aba648b20aa8630e19271840eef8eb3aec"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "openssl@4"

  deny_network_access!

  def install
    # ed25519 is needed by awscli
    args = %w[
      -DAWS_USE_LIBCRYPTO_TO_SUPPORT_ED25519_EVERYWHERE=ON
      -DBUILD_SHARED_LIBS=ON
      -DUSE_OPENSSL=ON
    ]

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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
