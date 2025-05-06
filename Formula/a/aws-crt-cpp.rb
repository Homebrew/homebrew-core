class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.32.5.tar.gz"
  sha256 "45d281d39ea1f70bd3310b2345395d3e5b414da325424938e095dde38d44cccd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89cb5502d8e5852eb61769fdd1343f2ae9936c42ec1e2b2060a5ceac210895e2"
    sha256 cellar: :any,                 arm64_sonoma:  "004c8107e2674de9f445684221ceb3cec0851deade28b5e1f44ffac1ff07cf4c"
    sha256 cellar: :any,                 arm64_ventura: "1abe12583f934acd6b35e3ee0193a3d12ecdbcdb717e50c5da90ac0a2adfe86c"
    sha256 cellar: :any,                 sonoma:        "d9f11af6eab0c14283432a28b6070bcdd71bf9fb22e5aba6980333605e6d2f8d"
    sha256 cellar: :any,                 ventura:       "8ba5a989aa8f1bb916a0168974980b0ee41c8545819a40fdc2fde3c939a191f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11baa040300a7b63590038ad9cbbae74befb9764310d658881120b1fa26e885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc23710ee558886064065445a77f3007a79ae9bc592e2085da4f543dd331f41"
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
