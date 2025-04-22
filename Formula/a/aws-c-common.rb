class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "ecea168ea974f2da73b5a0adc19d9c5ebca73ca4b9f733de7c37fc453ee7d1c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0218f6d2679676ceaaa6a49ce8aeaea818342d715be2f21f5ab08526d5e9e4f0"
    sha256 cellar: :any,                 arm64_sonoma:  "513cdeb3b84b1117efddb4631d33acd48b2836183378047c99328f991b7c6335"
    sha256 cellar: :any,                 arm64_ventura: "263c6f9012bc2e917aad7ee965c4b4bac766c8db274ce06439a3d27805dbc1af"
    sha256 cellar: :any,                 sonoma:        "32c37184a44a52ebea261d15907b35b49ceb6d4fc8ac19eda05029440747155b"
    sha256 cellar: :any,                 ventura:       "d7c109a1848a07cf585a8f01b0702e657ab725765cc2edc16e5bfb6c6343bce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2252602d441b097b90a2c383263d78e601a429ad4b98492a178a78ee9dce4cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "222bbd3f2b09890d4d2a2789ace9b2504cf757ab913e887da92707c5579ae193"
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
