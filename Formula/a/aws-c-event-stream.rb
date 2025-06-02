class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "cef8b78e362836d15514110fb43a0a0c7a86b0a210d5fe25fd248a82027a7272"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7bb1c234fc76207143274392938efa1c7912b82db36c2d7bd3e1ff31c2b21a97"
    sha256 cellar: :any,                 arm64_sonoma:  "22adf47866d7f196b5296469044723b94223a3c536590517605930a8c76461ec"
    sha256 cellar: :any,                 arm64_ventura: "fea45020a2341c46d9671671bc59bc788c4301615d5365e44cde87fca734f0f6"
    sha256 cellar: :any,                 sonoma:        "50ab76b1c74f6639a8af58478426de6e91201d1f0a32a81d3d20b63c6da44de1"
    sha256 cellar: :any,                 ventura:       "7cb1403ff68bd39da60c9051539cb3b9f88447baf5e199e6805bcdb8ec2a2ea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2903ade590868a253d877b9c85684fa1a128d263141a3360833ea67692bf3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4bd0d80ba4c490b1e0548caad95670e5c6937e5056b8945e11c2f58bde41d36"
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
