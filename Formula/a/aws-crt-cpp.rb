class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.34.4.tar.gz"
  sha256 "3f83391630dfbc061193c84bd4067f59301a954972ce86f7e52c4988db0f55cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a648dc4a3bdae34ca211d732302ca420631c6f24c982206e2796ca82f97f5ec"
    sha256 cellar: :any,                 arm64_sequoia: "cf931f883fe8c16e0deb009bee0b68a05e1f3d6712e1e6382bf1c8ff01d439a1"
    sha256 cellar: :any,                 arm64_sonoma:  "6ced1725f10f115320249789285467395b32aecea94cd5afc358c1cc8add7845"
    sha256 cellar: :any,                 sonoma:        "684e4e67321312ba9a95da5614a7b4b8c96b60e4cd3194422959d4ec9b2ddb43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1815d05fe5ea8cd8753afdcf48dca554e24ccb16a173d53f8a4414535ec2be99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad3cfe325c6975ba204e3ada03d341ed2f4695c39d96805ccfe8aad13ef92990"
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
