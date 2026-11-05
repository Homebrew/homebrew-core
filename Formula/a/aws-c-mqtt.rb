class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "7ef8f2a031992cc42564bba4e3f937fec925247051da6e0c730aa964639d284f"
  license "Apache-2.0"
  revision 1
  compatibility_version 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "295cbfb20f6c88a7470e803504bb8d62e7cafef57af60f641ae68812e2f361e3"
    sha256 cellar: :any, arm64_tahoe:       "5adbf3549a16bbdcd8575ebd38de7edbdd2ab4d4b63d35547f318b43ab5228e4"
    sha256 cellar: :any, arm64_sequoia:     "d4a40275e4144b3687db118ab98508a0c62a2c09d4580dea79ed7517436f410b"
    sha256 cellar: :any, arm64_linux:       "ae5325e0e0d043ce431bc2b9b8bac1ab6bbfc9c46c66e56fa32b7d849d622006"
    sha256 cellar: :any, x86_64_linux:      "dcb26e2faabe723ff5fe06753302211892849b9f3db673d55e012d4b08547542"
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
