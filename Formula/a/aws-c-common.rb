class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "85a05209b324ca330085b84fdada4faf6820592c34f252f0ceb61001f76bf04d"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b5ac6138d229cc5a9dc47d81b1072969c6540050bc3c76ee03619a0faac7c625"
    sha256 cellar: :any, arm64_sequoia: "1a44d886218124a699c77e9b1ee496bedfdd4e2c211d60e0fba0b62d74fcc819"
    sha256 cellar: :any, arm64_sonoma:  "35a7cf15492763d2179ead66d6c702d5782e5a730d20dd1a71cd55ecc3ee084d"
    sha256 cellar: :any, sonoma:        "838ba580a9d0ca9c135421728d400b0abd07f4a8ea8221e1a174a5b2c09d9a2c"
    sha256 cellar: :any, arm64_linux:   "3b9676a788f2a80abf3b0341d6fc8738d36f90ac85f82afbdb18c67d6f8eb240"
    sha256 cellar: :any, x86_64_linux:  "60c39211538b43416d9cc40a23964881c9226a3fd9b33260e6091211da1ef5ab"
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
