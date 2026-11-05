class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.44.3.tar.gz"
  sha256 "dbdeb941b24159e639a1e020a8d1e26b68a0bf9ee21f3a90971f42fe97d21086"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2333295234198e5ad84728628f53765d221e989fd8bb18fcbebb4c5cd032c0d8"
    sha256 cellar: :any, arm64_tahoe:       "7403bd2ced50e0d36291cda707fe06f50d88e243932558db791dc368a9eb4a4a"
    sha256 cellar: :any, arm64_sequoia:     "5a39ac4f04e2f438ecb62606616678214dc7bf360749b7772af28ab9d4b52e64"
    sha256 cellar: :any, arm64_linux:       "2b28171cba6f1fabbf1b8d48b6d9a381596bb32be031b116f0eecc8cfde445c2"
    sha256 cellar: :any, x86_64_linux:      "fcd9fbeb07f7c545f22664c6a0a5d8fe9ad9b9825c4782e09e80fd8683303564"
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
