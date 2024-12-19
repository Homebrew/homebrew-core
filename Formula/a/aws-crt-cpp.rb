class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.29.8.tar.gz"
  sha256 "a693b1b6a802dd8bf0210cbb9f01fd58a95c851309a10a221e1ba7496b81384c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4fb45112cda510f11e3bc50cfcdddc299675fc49bf275b5deea91c0e78d277b2"
    sha256 cellar: :any,                 arm64_sonoma:  "5864d1f4cd182a04f70c66ee32a4e357988d1dd8df6cba1252be8d8f3ac6a79c"
    sha256 cellar: :any,                 arm64_ventura: "a485e8c7260a36af652a0ed37db73ef5f02d5d66b3b963e65f588d99743cf0ae"
    sha256 cellar: :any,                 sonoma:        "e4005a767a5df41b7b7fd78513a97d9779bd61bbd2b1bb4291b975ed1e495dc4"
    sha256 cellar: :any,                 ventura:       "e7751d8e5e3a7e161f4d730c1a9f75dbf3cd687591a813bc5916281f2e740c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "059a8195fe53bab96bc26798ee1e49c5aabeb7913b97928f2813f4295a044785"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"

  def install
    args = %W[
      -DBUILD_DEPS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <aws/crt/Allocator.h>
      #include <aws/crt/Api.h>
      #include <aws/crt/Types.h>
      #include <aws/crt/checksum/CRC.h>

      int main() {
        Aws::Crt::ApiHandle apiHandle(Aws::Crt::DefaultAllocatorImplementation());
        uint8_t data[32] = {0};
        Aws::Crt::ByteCursor dataCur = Aws::Crt::ByteCursorFromArray(data, sizeof(data));
        assert(0x190A55AD == Aws::Crt::Checksum::ComputeCRC32(dataCur));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-laws-crt-cpp"
    system "./test"
  end
end
