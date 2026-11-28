class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "a8f6fe8c696059ab5d4ddc45c78df21e7abc3391dace2dd88f285439e8d7f6dc"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    manifest_sha256 "a49387a53d2f10d01105089c9283cf9af0d71e66a304eba08d904a7e3915002f"
    sha256 cellar: :any, arm64_golden_gate: "fa86e03f9edbb2e8f02ed9b2aac76ab4d6bd97ee572a2ed575a8c74506de9f2b"
    sha256 cellar: :any, arm64_tahoe:       "c44f9922a28d162cac136e86cc3b9d340a1ca2ba3276525124c439ff993032f7"
    sha256 cellar: :any, arm64_sequoia:     "6de06cf092f51f4c0a1629687b4a2b1e6018d7e28d9325c306db00f768cdaaa3"
    sha256 cellar: :any, arm64_linux:       "01c3f421c048028c8cde371918f8179605f23ed1c7e02b669914d7f6a8b681f3"
    sha256 cellar: :any, x86_64_linux:      "a2312640107c225c23147ce471b4b8270e650ce6effb8e1436e6f8d29f40630a"
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
