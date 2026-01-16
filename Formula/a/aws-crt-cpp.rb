class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "b91b70c436bd2d35a8758871983312bea63696ff34ef8e44ec1b86072db28a18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e925b71fa6cf24e333ce16305befc3f72e639be7df59fd5db43c455554e8e85a"
    sha256 cellar: :any,                 arm64_sequoia: "8f12c913d2f0bea19473482a1610eb60182b980080fd38bbdbd0acc4440836b8"
    sha256 cellar: :any,                 arm64_sonoma:  "221ddd056c35f4f1b7da5f07d594fb91a5d3645614b0ca49d11df02e13e6ff68"
    sha256 cellar: :any,                 sonoma:        "5ae71395796f394e450fb28942577e26ac36e82b0a8c9838e57d2bbc955787b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c88334f1e7cdbd19fdd422582c881a3fe5799c721f715d30f50727e7b3942577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbe0d8d5e787ae8757d873f610c2bee79653b8211f42b69b92e0ca306509964c"
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
