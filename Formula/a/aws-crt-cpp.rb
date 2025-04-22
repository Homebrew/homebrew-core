class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.32.4.tar.gz"
  sha256 "5ded0d4a17e3e99fe0755dde49597c1f17edf65a68df7ec218d3a9331336a3e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ea803f4654d9b0756e35315606cad76df66f8b72bd9a17fca4fc3bb96c7f858"
    sha256 cellar: :any,                 arm64_sonoma:  "b0129b6a37cd24cf74c99afea13b96e1472fa46d0504401c67c14ff3e81dd1ff"
    sha256 cellar: :any,                 arm64_ventura: "74d56e7c315f95d114cf7809f86b57c877d99d4184493236ef0d5573b97f36ec"
    sha256 cellar: :any,                 sonoma:        "360c97b014404fa6c908ce59a940010890f13dcca1d5eed8e36571e400939bdf"
    sha256 cellar: :any,                 ventura:       "268a544f7592eda7c66f09889e55a1c49519672ed633d6570021c9a266a12943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be8d97541e63d9ef4efd5d6b10fd6e776d9a0cc8b5cdc1978c641f5e8ced8641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d57b82e02ccfd9310e5961b37d60b05958e17284600c6b32fa16d37b498de8"
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
