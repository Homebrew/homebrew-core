class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "6ecbc5d8d086fb2218f6e1be4d643a6eccf8ee20b2a52055758377b06f0c2ad2"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c041b2fe2cee22cde5ccff687f9cbf6f32d5a851c32aa38221223b5f606190e8"
    sha256 cellar: :any, arm64_sequoia: "a54e3aacfe2fb1604c505e33195468421b384b58186be9d07d46eb95ad86a715"
    sha256 cellar: :any, arm64_sonoma:  "a305fe88f0c0a2e4dcec7e3a17ce066b0d238b8a2c2e53b9d00e3638ccb21bbe"
    sha256 cellar: :any, sonoma:        "d2965fd7ec682dde50710302a675f4057d855e72e6acaded93a8318a46ef0431"
    sha256 cellar: :any, arm64_linux:   "4d27da33a577d460b271e5b785f7ade3a81ad5ac5b0d683449207d3c1b57a589"
    sha256 cellar: :any, x86_64_linux:  "6a944770805aab9d8ef56d2869e4ed5531dba9b93b897db7089a0a9da8679797"
  end

  depends_on "cmake" => :build

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
