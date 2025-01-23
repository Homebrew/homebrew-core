class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://github.com/awslabs/aws-c-cal/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "4d603641758ef350c3e5401184804e8a6bba4aa5294593cc6228b0dca77b22f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0607a3fe7bcad233f298e291e61156e514f03f117000d71d4ff97321415937d3"
    sha256 cellar: :any,                 arm64_sonoma:  "023901e6e18522fe48992259c6d2071b8dcf0890c4f7dc56cd47887b1ae447f5"
    sha256 cellar: :any,                 arm64_ventura: "9a9b77a893e4a0067e6f1f20af8ffe564090beb3e07280f5499ad783be3d348a"
    sha256 cellar: :any,                 sonoma:        "215a4558417b844d8c3b2864b07824437c830e9e778ff3e4f0ac988a69294b98"
    sha256 cellar: :any,                 ventura:       "d85a325d01fc261df4f1e96685bf11566b4dcc9d7eb130bbc66c71abd7477acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6c321e0f5891b906cebd600232165e6ae17a97c6b699173dee2461c42f5e79"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]
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
