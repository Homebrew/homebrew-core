class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "7180dc078c8e815856bcc21c88a57ec36e61893ffe4585b4ec855284c0d96674"
  license "Apache-2.0"
  compatibility_version 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "58663dc8cd1d79ad5570ce38ae8d37d60a22528248995c2c83ed0f70a9bfda76"
    sha256 cellar: :any, arm64_golden_gate: "f41ecb8ee64a9fb17ba1e6cb1f9e6e173ec17f266d2043edba23563341faa723"
    sha256 cellar: :any, arm64_tahoe:       "06e0c6fa28e620fbe938d12f084a2e3582e6c3eb5d9905ed7026c4509c5c5116"
    sha256 cellar: :any, arm64_sequoia:     "874bd05f40f28b50119ff8719f7156094810975695bb772389f753716c8d7f26"
    sha256 cellar: :any, arm64_linux:       "097478a069b4bab8395b8467c4babdb1c9e6d3ca50422e18ad64cfc05a2d2e05"
    sha256 cellar: :any, x86_64_linux:      "802bc6fd7d4982cabaefb5ad43d7056172151b611ed8646340dd2f0efa6b1d08"
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
