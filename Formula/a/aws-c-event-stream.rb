class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3a53a9d05f9e2fd06036a12854a8b4f05a0c4858bb5b8df8a30edba9de8532b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "341c67fa8bc012d3808b06a909f07c51cb8ad0bcf19d30a498f598b7846f3fab"
    sha256 cellar: :any,                 arm64_sonoma:  "593c848b1436f0f925cb39de34a24b5e41588ed28a87e471c0ff02e591a90d44"
    sha256 cellar: :any,                 arm64_ventura: "58d9787fc6e7308d1aeae5570a5fc527ee23cdbc6cfb38bc54fff0507afa8808"
    sha256 cellar: :any,                 sonoma:        "54e1c0118960594197f0485588d45e48d043b34863597199023b4f073be0bbcc"
    sha256 cellar: :any,                 ventura:       "b353703f2a89a6d5cbf1706c4a672d606ea04b910d3dfbf72da48f42d9741ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9cc5974ad9d4ba76a472638f30123e2e8f5aaa77885c6d0545b4e03fe65ad82"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]
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
