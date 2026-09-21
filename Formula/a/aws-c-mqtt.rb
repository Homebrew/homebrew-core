class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "28d9d9edd5f643b5a8db4e4f116c09d0781fd3715341ad3b039da3233a3d7b12"
  license "Apache-2.0"
  compatibility_version 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d01022af3c1a544c5eda5da760529409163fdff1f49287576d54363724afc2a2"
    sha256 cellar: :any, arm64_tahoe:       "9bbbbeaad158d42ac8689afc77e211df4d345a336722fdde355ad437e21c2f92"
    sha256 cellar: :any, arm64_sequoia:     "c5faf4a038b12aff6a92847f6447d8efc583ffa77f56d869de994a27b081cd45"
    sha256 cellar: :any, arm64_sonoma:      "97b95b6ddb79deb0fbc3e13fbf5ef35029aa1f5e1dcc006ee31415caec77ed37"
    sha256 cellar: :any, arm64_linux:       "d705fef6a3536a4fc23bd4be59ceb5a147f80c80ed8005df2be94dcdee32646f"
    sha256 cellar: :any, x86_64_linux:      "61c27a2ff01415857feb191245f2e63bec0c17feaa3e8ecf532343476b3ff62e"
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
