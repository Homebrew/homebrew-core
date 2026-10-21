class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "7ef8f2a031992cc42564bba4e3f937fec925247051da6e0c730aa964639d284f"
  license "Apache-2.0"
  compatibility_version 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b60cd33f86d7b104ac234dd5a168bf9ecfd741b609b05bd5d623812338b580e4"
    sha256 cellar: :any, arm64_tahoe:       "a3ffaadfa50c2158db9a3884499a89e7f3723e03885cfb853c03dcdc00463eea"
    sha256 cellar: :any, arm64_sequoia:     "3b7378d9111beba866d90f2bb12647ff554112b267b68e3e066c310698dde012"
    sha256 cellar: :any, arm64_linux:       "85d2e81b3bdddc5cd25768dbf18ffd7d66c1cea5c5e3241ec09fe2a3b5c0f3d5"
    sha256 cellar: :any, x86_64_linux:      "578e8d1254b86a3bd8abd1e6d8548ea73e7f12bb938059e001a17a74c98e4003"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"

  deny_network_access!

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
