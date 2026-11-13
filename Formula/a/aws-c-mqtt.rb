class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "44378f1896274227fdb720a39a49f83978301dfe95107b842733fe6e8d56e085"
  license "Apache-2.0"
  compatibility_version 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6df04fc9dbd5702e0c68a6e7accb0d00b02f950fbed688dcd8e97652940c3561"
    sha256 cellar: :any, arm64_tahoe:       "d26778a778841ca6f466e9ba0b28940a204b1949d70e7f9534a91733f7b1247d"
    sha256 cellar: :any, arm64_sequoia:     "3b3e93d6bd065a792742aabf989f2d59b5d2dd263edc9d3229422b04bcdb4ae1"
    sha256 cellar: :any, arm64_linux:       "2a0c7ae38527e71172beaee070be797c820271ac0a510e2cf5c9148ff269f154"
    sha256 cellar: :any, x86_64_linux:      "eebbd1b74f491a41a757afae94065607710a07b72c5ad1f1f851bd12377e01d5"
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
