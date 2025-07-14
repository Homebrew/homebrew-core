class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "f6e55c8fd6afd7f904e08d36c3210e199ece5dc838f0f8457b43b72ec4d818e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5283e19a63fb24c3567df23812da28ab0ac34fec7e0b8e39c84db04fc456eee"
    sha256 cellar: :any,                 arm64_sonoma:  "cbcc542a39652c448a124ce9e1d7288852f5da8f52add2fae23e65c5f3b622e4"
    sha256 cellar: :any,                 arm64_ventura: "21e53582d5e7631f18f9c4f3fff90a037aeaba375a6f9f1daebc21ba0aa10c18"
    sha256 cellar: :any,                 sonoma:        "8ee6617040eb1f9f1ac07cb9efeb27cf8331359ea9749220af3e7bdb1246502b"
    sha256 cellar: :any,                 ventura:       "25fd40fde7fef95990b46097669b0a14aabd3c0be004f09f42d86bc992bb6220"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb790dfa0ee008b68bc102355b375a0bb4a8b455f6a31e1265457b3b4d66b48e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1b4ad68c75a3ba65e2c5bbeb34c921f648d01d5e4ef719a0956ce3a404d9cdb"
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
