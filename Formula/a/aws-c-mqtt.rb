class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "44378f1896274227fdb720a39a49f83978301dfe95107b842733fe6e8d56e085"
  license "Apache-2.0"
  revision 1
  compatibility_version 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "12861229e5032c021709f27ec9772b3cc92b0f44e098ded1d41259e455cabe92"
    sha256 cellar: :any, arm64_tahoe:       "c7fa8442bf50bbd1f62005f902910749d75d13815b957168d52e4124b75fccbf"
    sha256 cellar: :any, arm64_sequoia:     "907510ac98e9e738e0126ccee6eec457583ae5d9cc2c58eab5977737fa9b434d"
    sha256 cellar: :any, arm64_linux:       "1718dce9451409aa4633ef1e0acb6b06fea3da86d0af35c4d49904612b8a7a4a"
    sha256 cellar: :any, x86_64_linux:      "d8396d06a2f1f8779f880ad9f3e875573d8b7dd0f2ed73f889b98163063ba05f"
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
