class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "af3cd291d831b5fd65f789b7b9d34d856c6a3a5f6f5eb03bc23cffd1792d25e9"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e659dca20d8ae4ad62b48dde9587aa9e12cd1ee4697e1c1ba6c36427469c494"
    sha256 cellar: :any,                 arm64_sequoia: "7e434b205e41484f3c24f424756f6eae8e1826b0aa501fc8d890b28f76624ff4"
    sha256 cellar: :any,                 arm64_sonoma:  "423ea08ec5b219cea8d3e13bb24006fd86af0c746133455f707a668c007b4481"
    sha256 cellar: :any,                 sonoma:        "709efc974e0e8f43c0bfb4076270efb8c539af34274b9873ac02e109a0deeded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a403f59ce287c8b190334bc5ae7e793f6c98d4705c626f6c67d77d51aaff475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad4c14c80cfc6a7b81023046cb045e3b21c4b57f2dfa11ebe288497f3966cb8"
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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
