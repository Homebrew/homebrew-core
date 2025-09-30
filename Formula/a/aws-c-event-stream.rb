class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "5d92abed2ed89cc1efaba3963e888d9df527296f1dbfe21c569f84ea731aa3c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfc0a548bc6e46ce2ba3ab96cb7dda74471c6f02b9b2ca227835f495fe50fd4c"
    sha256 cellar: :any,                 arm64_sequoia: "66c081da6840b3767f64e9f948b243da2f660cc97fa87a1157dfdc4e48ac336b"
    sha256 cellar: :any,                 arm64_sonoma:  "772b25abbdf8a8006bf546e67e7205d52b707d55ac126409fc1e9e51c0e93003"
    sha256 cellar: :any,                 arm64_ventura: "e6c236efcd0e084f1231dfb6af750d89e2c889253f5abfd594f3c8f533ac4aaa"
    sha256 cellar: :any,                 sonoma:        "22583145d951b5e8cc709240c5e2a4226b4471618238e4583a6fa1eb69b041aa"
    sha256 cellar: :any,                 ventura:       "4971b2d3d25d37e3f0caa323270a48daabdd2319eed62178633f73a5edc55815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d03e1bd24c78f48f81057982faaba90343170ff0bfe9d21dfbaf86365df3f3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7aed2c28c221b53dc3007abb63a213679d8cb778cd7f4503552761f87a49d80"
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
