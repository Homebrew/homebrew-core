class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "8d22b181e4c90f5c683e786aadb9fb59a30a699c332e96e16595216ef9058c2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c65e5422e6f0ea47dc8ddd93f38e664d4909f00c4bd64f4fdd8e0bf03f1f67c3"
    sha256 cellar: :any,                 arm64_sonoma:  "11a3b01e5c4539cc499d9b966197557c8de444c18573f5acb3dcf4c5b03cfc2d"
    sha256 cellar: :any,                 arm64_ventura: "d6c46d5f0ead6f091d88026b127cb55e61aa234fccbce21f50e586cf14b95f06"
    sha256 cellar: :any,                 sonoma:        "554876896e6c47e40be41864baab7d240dc1b2b78bda600f04da3e98aa081578"
    sha256 cellar: :any,                 ventura:       "d1790c6d2e2c2e7c7e81e277064adf6045dfa6c452db02ef8c096d9ba311d79c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "302e8622357e2662ddef72ff717147f18d3e015baf6b1f827d7c3d9ec485fe17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae12ac2b10a98afe944d60c28f69aeaf004dd9cd32ecb97710d4aff2142679ea"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-cal` and `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/mqtt/mqtt.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_mqtt_library_init(allocator);
        aws_mqtt_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-mqtt",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
