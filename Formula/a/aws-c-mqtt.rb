class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9bc044a9c2f0d80c384ae6a6907c8817e0b40f673f75c4615c83b20f83140374"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a74167566a7bf2b20fe580263056776e6da26b09ecf15026bff6a9ba52e4bd35"
    sha256 cellar: :any,                 arm64_sequoia: "135c03cd46a4bdcbf0a4933c83a122427af00eea1cfb35f8135f395c126467cb"
    sha256 cellar: :any,                 arm64_sonoma:  "646ddca9d136d4d1f3ecc5b5da7a86ca6cea3fa72a64cd9990d15b7e8f3bfddf"
    sha256 cellar: :any,                 sonoma:        "a62dabdc4176ad788ccf8b5a2d88025c58278c1646d2e1e436b750cc6e340768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0caf142228a9426743089b42c7f2330a3057929d6ce48621a3c81c680ca65727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45311e3f0f92312f19913aa4e2ef0d151f53cb14872605ef8eab6e01c882495f"
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
