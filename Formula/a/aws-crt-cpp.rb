class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.32.8.tar.gz"
  sha256 "db44260452a0296341fb8e7b987e4c328f08f7829b9f1c740fed9c963e081e93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62bbaccce8159136f42ddfa91abae5b242371a8e640a7b1be9fb4bc84c910487"
    sha256 cellar: :any,                 arm64_sonoma:  "4460e396cdd8899104516f4dba6f6183784c5c9cc88101ab87235f5c15d3d892"
    sha256 cellar: :any,                 arm64_ventura: "d1fcd9ced3bfc999164734eb16df9aa83cec301dc673a72cebb985e905945398"
    sha256 cellar: :any,                 sonoma:        "b10168d01be4c2922c92a129c8a8224418d8ff8490a303047555e6c2836d1e86"
    sha256 cellar: :any,                 ventura:       "9ca14a03b0362d39a633c6b0ec663f3449cab7aff41e7bf6d1d66589743e970f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f8c3c367f8eac1d7e23d82b242529a54c74afdcc44f3ebeebddf55ab994729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4969f10a8061c23b37ca92da6296e9f8e7d25c766d1162eb8f6b67857dce8aa8"
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
