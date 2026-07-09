class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "1c1db6636254bc2dc129cbff0d14b44a98c4a6e7cc2abcafa7326b25f88e6b34"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b22765d01d6044f5bd04e70a6a8fa7d82999e5957ecfa4e7109d485760119458"
    sha256 cellar: :any, arm64_sequoia: "52f2f3587a32fa2300980cd787c011ed3056eb22832a476b9ebfef3e0e550adc"
    sha256 cellar: :any, arm64_sonoma:  "c0137794bbcf632eafd7c93fdb3ff604f19c633b257832c25393370f3ea14475"
    sha256 cellar: :any, sonoma:        "9b0efbb189ac6a20b02b2d562172c449c1586e978e3ac2b1adc9fb79cf166984"
    sha256 cellar: :any, arm64_linux:   "072b3e827a28cf463c8cea58b5b3492680a286bb0ccba4639d0e45902921909f"
    sha256 cellar: :any, x86_64_linux:  "b52b6f9719b2304e13d2621a690c1789f4df797b15176344432a94665322f742"
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
      -DCMAKE_MODULE_PATH=#{formula_opt_lib("aws-c-common")}/cmake
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
