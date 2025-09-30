class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.34.5.tar.gz"
  sha256 "914865ec5852dff46bbca6e679ebb2473e0d06d84d0462041dcd126881e47c02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8a393ae083506c462ffa34b8220c6e5282e3a84580fb33ba583136a556c9844"
    sha256 cellar: :any,                 arm64_sequoia: "0a1386cf45fb3648edad40e3c3ff9daa16826f8f85cbe316f1a87563a28ac78a"
    sha256 cellar: :any,                 arm64_sonoma:  "c84d7fd5141971c79f5126c00837d6b0bf4ea6d12c4586985db9ad05a8daa645"
    sha256 cellar: :any,                 sonoma:        "122dfbc628c78c5028fa0eb22ba3459dea43226431d7a90475277a37b733fafe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5368451c522e717d19ef85cfef6929d85d7296123d9b841f1af48661e4516271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ff8089e3435da9be1125580d6a9b58cdfa5216231376d90533c7ff9cebebb6"
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
