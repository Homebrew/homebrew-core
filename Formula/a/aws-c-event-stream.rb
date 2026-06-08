class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "334b2abfe0cb5c68d79d52525598fdd5f6052b93a17a78a4b1ada7fa1be252c0"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "814308827636ee3eb0e11c8d0a27c8e75ce713be0ded8598e71de9d0324f5993"
    sha256 cellar: :any,                 arm64_sequoia: "5d4e583cf3c1ada0cac9134fce473defff1ea1bbbb03ae718b8977e14978eb9a"
    sha256 cellar: :any,                 arm64_sonoma:  "09b75c0386cb914b0b79b60fc9449e0d90d7b5f6ef082d4327ffb087491bf6c7"
    sha256 cellar: :any,                 sonoma:        "0cb42827075adb020bbfc674ad5b6ba3bda885225204132884ee7962af329ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "399b4e3f0b823672c8e2d78dc3d6e03503482965e883fa444f2222b6ab2a2503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e83713aad44ec5487a487350a03488e0d5ad3d1302f38d2214ce35d921d919"
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
