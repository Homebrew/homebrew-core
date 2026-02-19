class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "e9371ffe050c24ca4eda439d58a06285db88b550e9cbec006d6ea21db02d424a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "798d6b235e2fd03963295b36e8a54d4937b10031d648a2e345999444f67d3387"
    sha256 cellar: :any,                 arm64_sequoia: "309a49f7da8a85650d94c3076b923f727253de59bccc51a4f38819228a357037"
    sha256 cellar: :any,                 arm64_sonoma:  "cd918cb03bb15c6051ef36a60240dcc883d4e0d0bc35ddff198d3fdc6fcd8023"
    sha256 cellar: :any,                 sonoma:        "a47e86b52a454595a9fc827e3605618cc03d8be6ab3bf29f2f186b4bf7d2f92d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c178e26ebd3f8557c68cd2eaf637e64d9a017bce20b0770465fe06a804684c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089b842aba72d6b21ea7c53e8f266bc12afbf3a7be6fef10812dac66c97b2b34"
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
