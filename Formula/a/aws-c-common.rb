class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "0b7705a4d115663c3f485d353a75ed86e37583157585e5825d851af634b57fe3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d79c4ffbddb4011ae383b8b9c2cf0382fabc6806fd683b9ab1b6cf9e81ba4c5"
    sha256 cellar: :any,                 arm64_sonoma:  "6f8cf2440d8a34087074a7bd675bd8735673d572cabfc99b0108226fe9bc4824"
    sha256 cellar: :any,                 arm64_ventura: "fbf3d7863aef4240e208cf76473e4ca930dda0391ca39003da952707179b0819"
    sha256 cellar: :any,                 sonoma:        "624dfc9bc8a150c9557c00664dc99695985136b4841f6a8b87f72349520a7a8c"
    sha256 cellar: :any,                 ventura:       "d09735e3b5a4767e98461ceff2081f81fd2bd61dbe9681646743fec149e9a79e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8887cea3820fd5aa190e10ca21dae743605e338c3914d6fd660f359e4adfd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d999a2fba4ee77feff04ed3d3a1bde1b4a6553bcbdadc0251fc8cce9fb635ac4"
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
