class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.38.5.tar.gz"
  sha256 "98ede8e39fe16d5327c3915613034d114e8304a2ec957510a6712b28d353d6d9"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d45fc0cc6b97770dfcc6acbc397eac2ce2d85ba05daa6655a1bfc70a51f478fe"
    sha256 cellar: :any,                 arm64_sequoia: "09e4568a7485c4fe009ce3c65a231648de526ff9d59c21850e56bc879118c0cf"
    sha256 cellar: :any,                 arm64_sonoma:  "b123875c1c837dc12c10f57ce0cdfb5b4a0f3303ae96c9e517e764fe3388d60c"
    sha256 cellar: :any,                 sonoma:        "3a607b0120f84d12f33916dc9d0053d980a976ad4b501a328ef4a586c2580b30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf8f90b8654c8da018eedbf7e10c6045b42b0f4e34073d04b0e804756e2a8499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0fd5904b750baf58391d2b17f027443ad535c69d14d9b09581545163d1f15b"
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
