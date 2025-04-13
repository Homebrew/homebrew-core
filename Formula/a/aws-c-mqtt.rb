class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "c2ea5d3b34692c5b71ec4ff3efd8277af01f16706970e8851373c361abaf1d72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fab417539f2ddd83f393a6cb13b8a71f58a2e5388bfd9575975a6e0c8150181e"
    sha256 cellar: :any,                 arm64_sonoma:  "62302d7a687dd8192ad29e4e489d5d9c0022e67b2e1d1566db9e3239e8383800"
    sha256 cellar: :any,                 arm64_ventura: "506b4475c731ca9c4d1e283aa16c16b69af84543ad0eade3150630b0c1e90348"
    sha256 cellar: :any,                 sonoma:        "d6c4929c89de9d05e630eeae7d7ab5c5915eccc3d43428bde36d68a14a53afff"
    sha256 cellar: :any,                 ventura:       "81ddc427c3509c1670ae57cbecd7a48c6ff5519620c773d92d7e4c6124af859b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "174400d40e8bb5f94b47022a496daff779bd6d8bce586cbc0199ce63486158a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d88d034f660ba8ad256cc22aac109894b6f96fb494731da9e692c5184cb97b"
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
