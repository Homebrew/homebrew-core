class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3817ab04bf9c70fa3582a31243666a9a643ebe45f121f58d5fef5ff4787f8e0"
  license "Apache-2.0"
  revision 1
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f7a1f5d3435b401dadd509955225a96df462bcb40a470be2f69540fc04fbee3"
    sha256 cellar: :any, arm64_tahoe:       "a4fa6ea2c5ca98bdff56e4570fb21301ce43b666b06311c9d57fa5f17a349147"
    sha256 cellar: :any, arm64_sequoia:     "a14c5ec4f3ee3b3b825ffe9809c5ff027af33c04e77bb685ac80dd76c6135fd6"
    sha256 cellar: :any, arm64_linux:       "bd10341b5a3aae1d541bd8640db708e333bc51fbedef51b57bafcf332a5a5096"
    sha256 cellar: :any, x86_64_linux:      "7484d7bc56734a148d56b6ceb1b03792b5dbde78218ad94b7929a20f4c897fbb"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  deny_network_access!

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
