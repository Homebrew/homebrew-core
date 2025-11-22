class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "138822ecdcaff1d702f37d4751f245847d088592724921cc6bf61c232b198d6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d0343c9653e92155e51a9ed8c832b3092f308b6f94f472f2e902c1976f3f463"
    sha256 cellar: :any,                 arm64_sequoia: "904e876238629c69c369e96cc94b36f66f563bf4a17194b989174a81b8b210e4"
    sha256 cellar: :any,                 arm64_sonoma:  "442efd831ca5723844a129955e26d34850cd2154e10a6a6e3caa338e3533be52"
    sha256 cellar: :any,                 sonoma:        "36dfa3d4cc1268257c2e9c05cf18c678f20a9650e03201cfb115f187bac4cde9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67702cb1299ad594a38bf8ac8a5f28926cd9aa1aa60faa75270037120ff064d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c47099203ac0e0e63c6efdfb31097882df14b68f8817417eff2dbc2567fa8f"
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
