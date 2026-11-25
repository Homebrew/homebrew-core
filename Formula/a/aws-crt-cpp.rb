class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.44.6.tar.gz"
  sha256 "a6ce8e7c811a8df99f1c26093fe7a9e5bf8d07f91791c9d5c94eec8db23ceac6"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    manifest_sha256 "ec681ad8557d8c4a275cd9ac24f420978c5d1dddd98611019ac1800bcc6cf8c9"
    sha256 cellar: :any, arm64_golden_gate: "0d88221ff37db2f8b57ba7e75a9721686e71a64b5c03c02a28b8bcd6c0b5ed08"
    sha256 cellar: :any, arm64_tahoe:       "f4cca9b7d6f41062a4411a4472aa959ce2907b7fcdf993ca1b3ef819a688c713"
    sha256 cellar: :any, arm64_sequoia:     "b41ffa4117ec796358bfa84047b1e58cb510232edad3e4c76080a2001a10c695"
    sha256 cellar: :any, arm64_linux:       "130565c9b14c44ec7fdde7392f1fc794d776b9e636af4f8d3bfbb0968aa38daa"
    sha256 cellar: :any, x86_64_linux:      "ee4aba95ce43f7e5aff53f8a54818d7e90d7b4c4c15a9ddc7b79557bac37a06d"
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

  deny_network_access!

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
