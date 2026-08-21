class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "0a4da233f2532203b245d2459e4b12c9e556fee5ed2c92185d5e3f1dd4289c8c"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "33a89b5b46a15e27dbfda7b12b3e30a9e0f4c5e3302c0c6786a8099b88617ffc"
    sha256 cellar: :any, arm64_sequoia: "e0b437a06ec7a8d20290424e308d12937873c7fa5a0cd2449cca47352a094175"
    sha256 cellar: :any, arm64_sonoma:  "8d9e284bd042d9a619a6be69a21848093300c29ec38e838157f51fb8a8320fbb"
    sha256 cellar: :any, sonoma:        "9cded0184be16d852b1b88787e44d2f090a65667f4626d4cb9f8eeeaa57a0552"
    sha256 cellar: :any, arm64_linux:   "9f3eeb601bb70719bc5bf1395c8149b25b390223a713745e6e0891f06e20d644"
    sha256 cellar: :any, x86_64_linux:  "9ee700a5d468af1ce2fce2246338e1d0cf819a33544d0e1306f6912a4209be16"
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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
