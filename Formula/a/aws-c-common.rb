class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "103273767fea478545b75a0835c7dc60842baee0a191a112c72f904d22693c84"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "01fe36030620d2950ff5235780d576e025b1b8ff030a892f343e7c3a39dade67"
    sha256 cellar: :any, arm64_sequoia: "f2a5ac4876ea08a7cf58f4aa73837772de8c7b7d3dfb21f9e805a375abf3f1f6"
    sha256 cellar: :any, arm64_sonoma:  "bfc813903a65cf70749e02ec7edaa6dad58b5d4f3cd3328321f8dad8b86c7369"
    sha256 cellar: :any, sonoma:        "804cb729b432eeceb0f4d1ccbdf20ce95a3d87cccd21dbc9072a97a0511e8fbe"
    sha256 cellar: :any, arm64_linux:   "b64f5dfd392107f7e55099bc8e469303041ead2474b5c817420cbe26c1ce1820"
    sha256 cellar: :any, x86_64_linux:  "bd159d4698c4cc619f436744408546753949850dab6a29afc0babafce7ba5a5d"
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
