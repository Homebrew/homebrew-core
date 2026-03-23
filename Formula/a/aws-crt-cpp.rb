class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.37.4.tar.gz"
  sha256 "2bada1b314dcf6f4acbc1db648088bd4933445b02c13d8580ae1ed4f85d6ab84"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5ec3c7015a0fdbeed7aa66bdfce1871dac09456fcf27000e0f45612ee39a929"
    sha256 cellar: :any,                 arm64_sequoia: "90fe205d9c07be63f62d27a4ba5e8ab62e433546cb5dbe2bc7cbe6364f73d7bf"
    sha256 cellar: :any,                 arm64_sonoma:  "550a624614356e1673d50ec0360b72334763eeded428d5ac3b89d0cf391490a1"
    sha256 cellar: :any,                 sonoma:        "fd426c688d715d5273a7bce93c02ddd7b3e845e7af7feabfb864b6ea376775e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5a1f1d27195c348e662a1e182772a053bb7bb6a4b69a1470acbfaf1c37f6b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70496ffa35c4aa52fe9b7c088c93e2d41f40df810d9c5f9c2d778e61d5b32316"
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
