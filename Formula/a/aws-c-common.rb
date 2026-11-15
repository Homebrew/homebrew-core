class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "d00f08b4e2eb173c2d2ce25993b64c3263b906581bd0315845b9b31b0b7799dc"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0426a7ae5cb01544826acdf2ea6c56e576f5383b4d08927b6dcd38b95b81a526"
    sha256 cellar: :any, arm64_tahoe:       "e43913620c283b1569811124531443350617bc50b9a8851ba53d04f29e1acdf8"
    sha256 cellar: :any, arm64_sequoia:     "2e70d800cff9e112d37514dc63d01141f9ae9c0f6419edf689848efac8843e98"
    sha256 cellar: :any, arm64_linux:       "d70e388d65c0928f8f1bee91388fc652ec2f9e7300e556bfd5620081d242889e"
    sha256 cellar: :any, x86_64_linux:      "0eb3da233fbd6af97a80eeafc96a6d7c084d039bfaf33aefd8bf6217d0c96c29"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/uuid.h>
      #include <aws/common/byte_buf.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_uuid uuid;
        assert(AWS_OP_SUCCESS == aws_uuid_init(&uuid));

        uint8_t uuid_array[AWS_UUID_STR_LEN] = {0};
        struct aws_byte_buf uuid_buf = aws_byte_buf_from_array(uuid_array, sizeof(uuid_array));
        uuid_buf.len = 0;

        assert(AWS_OP_SUCCESS == aws_uuid_to_str(&uuid, &uuid_buf));
        uint8_t zerod_buf[AWS_UUID_STR_LEN] = {0};
        assert(AWS_UUID_STR_LEN - 1 == uuid_buf.len);
        assert(0 != memcmp(zerod_buf, uuid_array, sizeof(uuid_array)));

        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-common"
    system "./test"
  end
end
