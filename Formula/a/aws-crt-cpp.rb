class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.38.4.tar.gz"
  sha256 "2a0ec17b6e41d42b362d2502db26d07cf80667a2fc87a67352a27df9dfcb64a9"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02f176edc16a510b579fcf794d8ccedb98b224c7062cb4dbdf5da4c8216c4e61"
    sha256 cellar: :any,                 arm64_sequoia: "ae963d21df23acc7f0e1c082ebf74d44a74573d7f60a756e9e53a70596b5045c"
    sha256 cellar: :any,                 arm64_sonoma:  "d5579b9313dca861f97069655c43c05eb78d41648eacc758046a054cfca17d01"
    sha256 cellar: :any,                 sonoma:        "13b95d39f7ed5a94c0bb2e7d5ad76965c18e13e91ee07785ae180fe4e8c24524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e670c232acf51b73b496475a20e78efe718879c06c337c62f3e8e0527981fa18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f4d951957182169fd2fef22665f24c7bab0b7ccc636f3c125e4c8351473b62"
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
