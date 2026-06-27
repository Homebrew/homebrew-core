class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "697a8fb25167e12e704827e360b4f6b1af8ded48e11ef4d185b9cd72e17479c9"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c9739779e09158bbc5af714c02901277d6301225de3418fc720e6f218f82866d"
    sha256 cellar: :any, arm64_sequoia: "f9ebda4d2b5d499769c60e2da96967ad5185cbb5cf1f85370bd8f0fc3cd5776e"
    sha256 cellar: :any, arm64_sonoma:  "33291584257e6ac2def329b697a6928f1201b96c8980894ac8344d2f34be9687"
    sha256 cellar: :any, sonoma:        "7833b0c539bd0509617459e6e4de45a3988b21944612b6c0cbe34d1261f81823"
    sha256 cellar: :any, arm64_linux:   "d1cf81f10bbf56ffbb7d033abcb65205f9213e53599bbb830a1c896f98f41068"
    sha256 cellar: :any, x86_64_linux:  "b51a6aa9b3ba2d9ec4dc2323d2eacbbe7c04557120a553e9bcf0d972ab0d738a"
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
