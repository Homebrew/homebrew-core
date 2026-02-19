class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "d7b881f3154a4d7282aca1aab9926b2ff9a67de3a07b2eee3c229629520e492d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fdfdad7161f18bf2c39885ace11fbe8e05a423d09860e2c8a27663fec51aaa9a"
    sha256 cellar: :any,                 arm64_sequoia: "4fdc81e34ee250d5c3bb4e8165c54175d97d3dfc3b21ac9bb60ca72e128a9ed2"
    sha256 cellar: :any,                 arm64_sonoma:  "1a0ccdb68ae55d0fe54b9f3ab8b13027111ccc183f4f4afab4073c6748dbcf8f"
    sha256 cellar: :any,                 sonoma:        "0ab5f253bc3a5f981b62939c0d56b9854423525b9d02e2a1e814a14e19e82a11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d484cd3999b3b977ad2071f9af337936769e8fd6f520eae072423cc6c335a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e490ad8f531a51cdb4cd8f8bc6151c83084042b1fa93ebc0de99c8574292680"
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
