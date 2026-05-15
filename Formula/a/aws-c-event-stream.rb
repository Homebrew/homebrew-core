class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "88835b4c78462547917f622fd9dda45c991b7e356d9c07e2f0537d4d97fbd4fb"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "650f8d16066cb5429d0dc4f5ffd60fdd63c402c184d2fd9cd9c9592c8f3edbea"
    sha256 cellar: :any,                 arm64_sequoia: "d85395211ce132b8840e4805479503486f6346cc173712edba721acc90a891ef"
    sha256 cellar: :any,                 arm64_sonoma:  "1d418d1fe1df20d6b8d7c046da560d561e0f9676773f60654c659559f702d4fc"
    sha256 cellar: :any,                 sonoma:        "07eebede34f51bac83219ce13f1afb4fbf262460e8a21b4cf2dcf637e9a64e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bf7e81a5d77851096f96adbe69f216ec3d08aad50093c98071d114d99a7841d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da13887f8427923c7f22c7e2fa87d380d1a2be1c990cf6ef01ec73605606fda"
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
