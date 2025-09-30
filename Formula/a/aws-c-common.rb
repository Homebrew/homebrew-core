class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "02d1ab905d43a33008a63f273b27dbe4859e9f090eac6f0e3eeaf8c64a083937"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ad6ff40df267465d0f1c2629c2a5458e833edca5ab61744e6355d975ef5243f"
    sha256 cellar: :any,                 arm64_sequoia: "26a8725e75a099da71d4ce720c3270cb92df6cda1dd0811c9b4b1553d24f046a"
    sha256 cellar: :any,                 arm64_sonoma:  "d4b73a804c52ba4ac86c3f3436783b4dab389a3d4af055496c09a606ecd04a0a"
    sha256 cellar: :any,                 sonoma:        "fbadec428a15aab3af8ec173edaaf90f11fd1a216b7b30deadf3324a1b0b7a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a9b854a80e713993a9970a307378e52f838bf3b6fde871329dcf92b10747f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2855635b883cd40ae1d5c5badd2d319b88b35b19d7bf3bb059b5ee03ffe323"
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
