class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "3c204c2a457b0282dd7d1e7edf14ff81bced6928199d12839103e2d4311893a7"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ec4bed6d713ea571295f0fc9f163c2b4b3b721b5926bffd5b3e2ad8b03dfefc1"
    sha256 cellar: :any, arm64_tahoe:       "a782173235cf994ef8fb508e3332d75dda2b134284b2f76c7efd370c04599279"
    sha256 cellar: :any, arm64_sequoia:     "62e156eae13f76fccb112a6e75caf53fdf04ff5f404311b03387a546319bb167"
    sha256 cellar: :any, arm64_linux:       "881f8a5b6b35e94e270e905f55c12f9087bca1c7996542ba098684822ea3c07f"
    sha256 cellar: :any, x86_64_linux:      "94d9ca2a8534c7227ac34b6db8a063229f4b13186be6f8726a7c6de8377dcbbe"
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
