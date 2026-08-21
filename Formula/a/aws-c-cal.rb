class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://github.com/awslabs/aws-c-cal/archive/refs/tags/v0.9.15.tar.gz"
  sha256 "215dd31c12ea49c4f40aa7882a800f9648e4095cfcb2d6abdd27e957574ad6e2"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9be4b708353b4fc843571b73c2158e4f31b4f58fb83e798ac7647316b84f373"
    sha256 cellar: :any, arm64_sequoia: "ed9604374a8eb18b868848674403c958435597de24ee14345bea99cd1526e558"
    sha256 cellar: :any, arm64_sonoma:  "d20adad5a3ff2cb48d6259a1d7838edb35a44030bbd1deb4a5bcc709da5e44be"
    sha256 cellar: :any, sonoma:        "b68a7770b2afca362cb8a1907c4a56e5d58a076f31c3284f93d391b88b177f76"
    sha256 cellar: :any, arm64_linux:   "248336995ac68a05e9b79cdeb0f96ddd94c304e276835dd6882956bc4ca5208c"
    sha256 cellar: :any, x86_64_linux:  "2cd1004cb330e21c4510edaa9b16f1f3705673918f98bee487c2d598888f1120"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "openssl@3"

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
