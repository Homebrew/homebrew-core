class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "94de89f65d4917dd7381679ea3297d7304c43338158fa7bec190fa53c218ce90"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e35b6b14af4a4a7ae8de9b1e02d7e87acd8a055f51c68c3d1c66ecd7f7a72be"
    sha256 cellar: :any, arm64_tahoe:       "4b69b0bd82b1f824c4852ebcb40f059a809d68664fcbfd734582f57dbb0daeef"
    sha256 cellar: :any, arm64_sequoia:     "23c04076faef589323317f3983a163e0eceb1b370cf662ca1ac8dcd922af1481"
    sha256 cellar: :any, arm64_sonoma:      "caeb3dd620c850fb2b1078a07937740075706926d95154bafda9641153ae5d34"
    sha256 cellar: :any, arm64_linux:       "dc9030e091c219ac23215545dbec64234860f54c311f3bb325b38fd84182cc10"
    sha256 cellar: :any, x86_64_linux:      "af4dc71befe301b97a835a52c0b77c67b8e4f3760c990425616963e3f8f1bd3e"
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
