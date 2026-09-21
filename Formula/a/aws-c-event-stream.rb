class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3817ab04bf9c70fa3582a31243666a9a643ebe45f121f58d5fef5ff4787f8e0"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b172d78498a56d588fe3ca8bde4cfe043f1088fd85c49045075a365f3962fa5a"
    sha256 cellar: :any, arm64_tahoe:       "3421dc29eb43b10024b9344bdbccc0cc5ab8cfd9efa2206c0383c3aa6ee87350"
    sha256 cellar: :any, arm64_sequoia:     "eedbc91b7709177c64ffb9756c862c7c0970b807219260af9c8b24bc76aca66d"
    sha256 cellar: :any, arm64_sonoma:      "a0c0c268dec6ab79ccceb4d56b45a96487091af29247a6fe0fcac9ebd3bd60ca"
    sha256 cellar: :any, arm64_linux:       "a7f23e352bb33cb3c7714d974214329b901059cae6a3f5db30cec6c562926620"
    sha256 cellar: :any, x86_64_linux:      "99ad7d1c690ce59b6bd7a48732c608d070400df5854ddf248c72347ab852cf20"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-cal`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/event-stream/event_stream.h>
      #include <aws/common/allocator.h>
      #include <assert.h>

      int main(void) {
        uint8_t test_data[] = {
          0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x05, 0xc2, 0x48, 0xeb, 0x7d, 0x98, 0xc8, 0xff};

        struct aws_allocator *allocator = aws_default_allocator();
        struct aws_event_stream_message message;
        struct aws_byte_buf test_buf = aws_byte_buf_from_array(test_data, sizeof(test_data));
        assert(AWS_OP_SUCCESS == aws_event_stream_message_from_buffer(&message, allocator, &test_buf));

        assert(0x00000010 == aws_event_stream_message_total_length(&message));
        assert(0x00000000 == aws_event_stream_message_headers_len(&message));
        assert(0x05c248eb == aws_event_stream_message_prelude_crc(&message));
        assert(0x7d98c8ff == aws_event_stream_message_message_crc(&message));

        aws_event_stream_message_clean_up(&message);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-event-stream",
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
