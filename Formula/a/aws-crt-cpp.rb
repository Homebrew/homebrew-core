class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "bc81a9e97d004b354fcff5085567254ca837c2566973dfbaff67419ab6e2a57b"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bcf51effc1fdfca2e2fb106e542e9ed1f11f3d19aafdaeb3d8e5a371bf33dd0a"
    sha256 cellar: :any, arm64_sequoia: "1d3c0d73af7542a29dab760b8fb2dd2eb4e194640f9b4fcb5273693c1227aca6"
    sha256 cellar: :any, arm64_sonoma:  "31e89a6d23f0eba47b36797dd9e18cf0128b6fff980dd69c7fd17a502613859e"
    sha256 cellar: :any, sonoma:        "ae93b937b641ad75096cadd9176a9fb1dff6ee8b51607d718ef28cf9be84e05f"
    sha256 cellar: :any, arm64_linux:   "2c0b75cc2e4cce5e335de86a7572673c7cef743770b4da86432101528d477c69"
    sha256 cellar: :any, x86_64_linux:  "d1333adf118470845be083e297f1c0db96520683a2f7c8a165475d9a1accb99c"
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
