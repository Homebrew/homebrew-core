class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://github.com/awslabs/aws-c-cal/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "1245f007e83a66805f7afe80ce4825f910dad0068028dd8efc3b6172e2679be5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a9640efc53558c0d679743f3a3c83e03b96b0e452b1b955db9b70154eefbf46f"
    sha256 cellar: :any,                 arm64_sonoma:  "1a92bbf83a8759552839062ec749fc8e22f5bab6ae7e2e97d08b1d97f6d23296"
    sha256 cellar: :any,                 arm64_ventura: "7eaec172d79b9ea032254d3247750f268275b992623027d948d567f743056546"
    sha256 cellar: :any,                 sonoma:        "2bb8cda36accf57d7fa3ec9c674b7f1da79a5bdff671f03ddb0e0b237c6c8c14"
    sha256 cellar: :any,                 ventura:       "3f1e7f3d8884cf1ea0b81845410c1d17257dd7b564c1ff48c0fa798d066cc9b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40f843e081c414fbeb9ed0f171237f6412dc6b03f67bb842a9a2864c6d5603a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "025e7caa9bb17992fbb6eb4921e28c871623ca90c7eb12cb06d1c0c65f0f33b0"
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
