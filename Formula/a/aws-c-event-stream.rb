class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "5245179ea6349f3d21ce8c30cbd2b5c831673d9098235c2680e43c60fd6e6e30"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "98b495e574834fcd975fa1c8913a596f886c4c41caba60b5067f488aef3ab759"
    sha256 cellar: :any, arm64_sequoia: "39237fbacdd156d1313bc690ed7030e0c90897146edade1f125f4fc445d230c1"
    sha256 cellar: :any, arm64_sonoma:  "899155ff379e63c6567dcc43d96b10c9a8863de95a72576531fbd6d50c9fb1d3"
    sha256 cellar: :any, sonoma:        "66fb8b51a34c827a4cfa407fa1dd4234585fdd45a938200cc321e1de5e9e5cb9"
    sha256 cellar: :any, arm64_linux:   "4e0440a394fbeb4eb4a769ee27d53ad97e62a646a5c3a31fe34a3fde25d4ff7a"
    sha256 cellar: :any, x86_64_linux:  "047e52624f511f8119555a218098a017c6070c02a132eda0b51c2317b60ab95f"
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
