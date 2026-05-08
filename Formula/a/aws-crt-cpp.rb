class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.38.7.tar.gz"
  sha256 "5d0010af3e072f1a2712d3ee6a94363a48e5e5f1d9c6f35c1f8d6cd4f53b50c6"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf568a08aff3b1bc260075ded58f32020c9323bdb5834aa41b42176dba2aa841"
    sha256 cellar: :any,                 arm64_sequoia: "4678054c721e46b6a450484946e96dc9897ab02c227588567c4b9bbb1b0c96e2"
    sha256 cellar: :any,                 arm64_sonoma:  "71a32315417cd21f1e7138fa485134ea0c1ccc382a80b6c2327033eabbfdf5b6"
    sha256 cellar: :any,                 sonoma:        "39e07fe7b47d884ca919b048a3558fd56670204c610725c3a49033beff162b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "956157d2d7a3eeb899604c3a8458243a31e7c6b1d194b097a61c56c334b7886d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edf2cef77b3ea7986ce0b8bab624714f6789ee99fb522fe259cfce86d969f2ec"
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
