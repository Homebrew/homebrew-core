class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "3684076ec5da899074336722ba58a01f7166a1a2e5ad72f846f6fd468ecdf2ec"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7afbfdab50ceaf5d67d529bac53a8df8fec50191bb4ec7d696ae1531c0f4de31"
    sha256 cellar: :any, arm64_sequoia: "7c5bc70baa77e08f467996e48a92c6ce7e6b503fcced0dc7958fb3a1f7dc1936"
    sha256 cellar: :any, arm64_sonoma:  "a2ce4f9fae432826d88f2d479af1d909e8f7c1e214f1e801fc37a644bb90ae41"
    sha256 cellar: :any, sonoma:        "421ce8725aadc8a09659f72927938808adad8d1666a7e35ccc9b68008de281d8"
    sha256 cellar: :any, arm64_linux:   "f3cc81fd149a9cda9d171283b80baac825cfcf4bd378b15a98ab9aa4c887810c"
    sha256 cellar: :any, x86_64_linux:  "aa3cb36bffa6f69804844b3c7fe7e2fe3987292ed9f01e2708e9d5639ee4e612"
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
