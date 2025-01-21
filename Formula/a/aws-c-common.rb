class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "d0acbabc786035d41791c3a2f45dbeda31d9693521ee746dc1375d6380eb912b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "feb8ed918e06ab4610fe438e63dbcba78768a33b5c4c62018d979f31c835d4ad"
    sha256 cellar: :any,                 arm64_sonoma:  "fecdfa8cabaace2c3620a4d938d95ff321000b991392a4ec2011f7bcad156709"
    sha256 cellar: :any,                 arm64_ventura: "42556cb5e04204961b7cad584f6a769d93c6a95204da59d7ff4214cbc1e080db"
    sha256 cellar: :any,                 sonoma:        "65ca769b24f3f23e4aa6acba353bb248bdc62a2ef1c7635dc9a266a9a67de8b2"
    sha256 cellar: :any,                 ventura:       "ca5b0185b27b5bd4e95b7ff4ce7853b2857bf1aa41759f8e46dd7d774adfe099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1213d80513c4334e8acbd7eba9cba5d8e37ff566e0332f7b2525fef188ff3a75"
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
