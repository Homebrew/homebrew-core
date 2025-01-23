class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.29.9.tar.gz"
  sha256 "d445ab7a26c03a0c0cbb9d82203ee32a56c762a3cef1874783783431b8eb015a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "113e2e395df58aa46528374eba80bf75ee0a357e77bc197a940e8acf7e8fefba"
    sha256 cellar: :any,                 arm64_sonoma:  "70a93f20828e6e15392b6c022009ea9866aed91a01c8368d5c832fda007469fb"
    sha256 cellar: :any,                 arm64_ventura: "b36743bd9e81ec6ad3248b4ef5104075c38eeb2f7152eacf9ee0d602ab83e9f1"
    sha256 cellar: :any,                 sonoma:        "50f4cd28d792c92f14c96cc81047bc077839944b33920d88d0c5244821738f90"
    sha256 cellar: :any,                 ventura:       "4e371816120b84b51c124fa67ca5b2901acfd74a583b3b81f141a383162a91a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ceaa094bcc096ab8ecacfd7fdbb43e0fd970993f9188b719205857e8bcd29f"
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
