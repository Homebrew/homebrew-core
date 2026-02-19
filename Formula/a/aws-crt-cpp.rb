class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "4cb6f65a1116ccc73ea9f068ce0bee98e906f8e0f96229c91681a85b207ebacc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36c685f8bb7da0ae3a2894b7b5cf240ced244afaf0499f2d5a4563b74b1d12f0"
    sha256 cellar: :any,                 arm64_sequoia: "bdf2266d75ae2fcfb23d9c25307242ed87e5e3c10f5a94d366e45dc406d6bd0e"
    sha256 cellar: :any,                 arm64_sonoma:  "0bdea8bd653aca48680721331fe6ff4f31be07b75a2faece9b2b6626d4848a0d"
    sha256 cellar: :any,                 sonoma:        "bb87f86231e6870ad373797bbcb21df2301830f8a5fae049dd1c04dcb0dac228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d43fd1925a17c768e3b85a57f2626aabb2900fdf0da156e76940fdf57b35518b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7e4a2d10543390f59c8e44b3b7ad7446849547add16561ef3719c11f5d09f3"
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
