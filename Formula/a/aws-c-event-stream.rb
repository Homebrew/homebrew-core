class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "22ce7a695b82debe118c9ecc641ea8bc7e59c9843f92d5acf8401fc86cac847a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b7194612b3fc7066ed7dd7156fef4be8fc067efae76d327bcb1000ad0319442"
    sha256 cellar: :any,                 arm64_sonoma:  "dc180e88a427bcffa6edef71e6a764f8cd0ecad2f7e900057de15ee47b78fac9"
    sha256 cellar: :any,                 arm64_ventura: "62c38f3fd66eb15aad20df17cb63fdaa49b3af5cd2773497a516299f70672984"
    sha256 cellar: :any,                 sonoma:        "fb56a45c8f92e621ce7aca558ff2a406cbf789a2354a32361bac030773e1b1b2"
    sha256 cellar: :any,                 ventura:       "1957768c16815d76b898d88dac5a9b654da84c26c12ee8838f6d41a92c71f26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0e4312228d0c336317444f659198ad1742fbf044efd6a463437fe07fda6baf4"
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
