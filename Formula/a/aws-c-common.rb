class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "a4e7ac6c6f840cb6ab56b8ee0bcd94a61c59d68ca42570bca518432da4c94273"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62216a819dc3fc7e4534b1aa90bf5ceadd0b3ab12e90c3286755e7eeef3e1f28"
    sha256 cellar: :any,                 arm64_sonoma:  "735111272de4dbc4d9c0a95a867841a78288e3f4ea87464916c2929c180b9bcf"
    sha256 cellar: :any,                 arm64_ventura: "7b5aeb2235e34c57c7cf649b99a96f41ef422d97a4a835d2df0f7979130f7ff1"
    sha256 cellar: :any,                 sonoma:        "0bcccffc3df99c0bc4714af8c5991c49b849e063b0db11542f11956987966c09"
    sha256 cellar: :any,                 ventura:       "3788ae3a3386b973dded01eb568b2c44aa587ef064aecdee5b14091d3ac1eef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bace9eb894ecc5047c4e2d617c4650a2f00aea7fec4372d1b9fb3a089b51b5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b1efeeb051f62759b0fac6fe18fc0bd34caab96b2be74ebf4925325207db30"
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
