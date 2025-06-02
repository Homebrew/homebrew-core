class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "c54d02c1e46f55bae8d5e6f9c4b0d78d84c1c9d9ac16ba8d78c3361edcd8b5bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c9a40bcf191ecc15b602df13e0aedc2a238f25b8b4124c58daa23258f7f4377"
    sha256 cellar: :any,                 arm64_sonoma:  "60ec9b96e20bd1bc87ec5855ab86e001c22c68f8b8db2d4e1e27aefb4fb00ac0"
    sha256 cellar: :any,                 arm64_ventura: "01549a46706b48cc6b6c3cad711167afa3c11cfdd5a5b675fe2601a515222bd7"
    sha256 cellar: :any,                 sonoma:        "3cb326fb51b7f58d482b449eaa5aa4b48c785e883524e6b625e1b05bc8e0bbc9"
    sha256 cellar: :any,                 ventura:       "b654bc8709c63ed39da7add79eebc672288ff2f1d8b7fc55425c2a7b647c98aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fec288790bff6b75e15f61d28dc2767cdd027709bc06e1093e1b4a5e38713ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f8b230de45d27c392d155e925bd4e09a443fcd783c347e15de13db7e43d1a53"
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
