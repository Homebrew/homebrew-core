class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://github.com/awslabs/aws-c-cal/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "0e96e0067fa921768e07b5b4ebad82011ccf474903e9286419ef428d68f317ea"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d74b61308b5039c19dfdfc58c871374fb809a16999c7740c48d4052fa7e4bd0"
    sha256 cellar: :any,                 arm64_sequoia: "248f055eb7cd3d71820fd0dcb2ba820e20fa211c82006681faf0a1c8bd2daf2e"
    sha256 cellar: :any,                 arm64_sonoma:  "8073af4dc8791f3bf1d1455c83162500ac87dce60a90938bb4f42cc8161df5cc"
    sha256 cellar: :any,                 sonoma:        "259a059e7c9bc79348ec9ca45c8d3c87cccc4adb890d580eba3b371d92e29de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7f7556b8df2c13d3cafac080c2fa4ea189a28e736ec1700946a4d8b52b9aefb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "475d84c4fdd16664d923876937c3336fe0713563f380789a97a0c159b31f8b94"
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
