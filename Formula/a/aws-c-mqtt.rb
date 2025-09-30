class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "1dfc11d6b3dc1a6d408df64073e8238739b4c50374078d36d3f2d30491d15527"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbc29f69f9027eda095e14c2e2f230cc8d9ea1f894ee99c2340f399809a88917"
    sha256 cellar: :any,                 arm64_sequoia: "8e08c006499b410fe17dad331e6c6b393f437b3bd3dc9d5ecbfe3bca7f03e915"
    sha256 cellar: :any,                 arm64_sonoma:  "32344e5abda84e1faa9c9bed67a75c9fb75c7a48d409f2948470de6856e1d947"
    sha256 cellar: :any,                 arm64_ventura: "27d44efd0274a41ce0607cd6937f30b265b7ad48c4665aa7728e068b435b8e95"
    sha256 cellar: :any,                 sonoma:        "1e3fe8c6e6af3c549bd43b066faf77a52accb1cf9f37b1b61c8b804fedf93bfa"
    sha256 cellar: :any,                 ventura:       "36791013670e5b2f7be5475c6dc1d2f81c7840d816e89a4bc901054d06a2f7f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6821229b25b0c86fc065431bbf256146c6c4c374acf4dc2a641332c549f1f455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c618725d7a3c5e236c847ff53cf18c9fa36c12b6873d208ec32d017348103cb"
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
