class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "66f3f5edff4ad1f765a86d3342b6017d0f29f950c1c24f8c1edacdc895202edc"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "211ccfe69cbe685448dee45a1216cb13e5a7ad55aeaa7c34cd6724b52628c3e9"
    sha256 cellar: :any,                 arm64_sequoia: "bada874516362f98cf8bf5c060bd4b342f33011c743fdce0180cf749dd5a082a"
    sha256 cellar: :any,                 arm64_sonoma:  "4468b1ae94cb9d1b3d4c6d213f72613b52f10e855c26a4550639811a18cfef25"
    sha256 cellar: :any,                 sonoma:        "7531d7c7f00deb50495d492bc43c54b41b740f8cb4d48b490b5a40b00dbb5113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "201bdf663942e6270b90c00020f8a6f4f48636b97220b8b4df23997d6a5c8e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4152462671d2e4d77878060b6c395c0f011823c568966b7460c4c03f9d311385"
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
