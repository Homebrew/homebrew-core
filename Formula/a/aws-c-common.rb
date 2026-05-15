class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "690939a45581c8376f96a6315466e3a2344d6b31dfa92f4d24b8f6ce96a654df"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "577dbbef5556778c04700b7a9d7a052acf526462b8b5ffffea8a70bc892bb009"
    sha256 cellar: :any,                 arm64_sequoia: "f2de6cd4a970c1471257143422ef084b1f0a20de13ee827324157aaaa0e607d0"
    sha256 cellar: :any,                 arm64_sonoma:  "f1e11ad7e53eba2ee1d62ffc29e0a143b6eebdc3fa4a752f7cac37709a033ea0"
    sha256 cellar: :any,                 sonoma:        "2104d37c63787d944861cffd80d376c024f2923c4777bcf528d158429bf29285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1ef388fdc3f65fae80430a9b82d892ae7e960276c0c5e4286b7ccb2e8015c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d364d4aa8f2550ea36f903fc7bbdf116c87f0202f065551a3d7e12a9ece6d10a"
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
