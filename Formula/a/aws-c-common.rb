class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "52023547b68ba47083289f8ec19e2143c5c92a68e83dd33c18088ad20057d7f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab0d18f8bae9ab40fecbee9027a277a3e46d06f6d3de93fa32b1e29429e0606c"
    sha256 cellar: :any,                 arm64_sonoma:  "52aa1798c7b137c2b3b48361dcb60685fdbdbb5f68899c2c39bc447c13facdc0"
    sha256 cellar: :any,                 arm64_ventura: "65076175833aec9aa5e6694ec92085837e7494b991afd2b4be07db6ada0d747b"
    sha256 cellar: :any,                 sonoma:        "c166e0bd14fdc490eaf51993d5024190940d3617de267f9df266f179b9460210"
    sha256 cellar: :any,                 ventura:       "881cb1c7c701343ab41828b3d664638817bc83b3ff76336ef701da16e46455a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43aaadc1c7d1646ccf3dbf5f3f346b3f47eaa058524e149765b0efdc5d0de583"
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
