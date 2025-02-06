class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "88115d6f3e4f79d8b2544ed8a95d8a9699985aed38aeb4779d7c9fffde1fee58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bce1428c815e42ad7aad44f8286b6e4ec706286d51369e9f997415e63d96700c"
    sha256 cellar: :any,                 arm64_sonoma:  "6ee60c791ec4a97d9de6381bc52bc7e6fd3d5d4849cd573a91db7f9e8eb644ad"
    sha256 cellar: :any,                 arm64_ventura: "e715063364d59a27a7af8777aae947643fc2958e6d45c5c438ceed082dee5cf9"
    sha256 cellar: :any,                 sonoma:        "a74527911838d4ba2a838c823fc74d89eb6709e989c230d4f65d4f00a42eebc3"
    sha256 cellar: :any,                 ventura:       "8a7db116f65d76565407377b4b7f9b1eefe00253aa37d2e8d61dad3b2189e857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a52e7b56ae58cd67b74730164406213426960f0b5d2fb438d9cedf6e5f45c9e"
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
