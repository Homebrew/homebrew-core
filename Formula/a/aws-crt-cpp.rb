class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "6f955f7d9a671d21da67ecda222ee70753c648f025207812229518e3ab2b242a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5a35cbf85e430f05eec003461c190b9687594733b1cd0756921878046c9b622"
    sha256 cellar: :any,                 arm64_sonoma:  "2a62c46dce60af8764bbcc6eb9c5b92fb80d3261d4551c923933f20ec189fa61"
    sha256 cellar: :any,                 arm64_ventura: "3b61e1687fc11ea9c7e6f8b46fb7500bf10f471db518f960a2afbbb669d54188"
    sha256 cellar: :any,                 sonoma:        "82edf6584546cc68602ecbd7fcab5249c3232c158312f4cb36c6212933a60ebe"
    sha256 cellar: :any,                 ventura:       "461e08249db0169716c38001255d89d4b3c0fb89c7413fa08044b287c114613f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da134ed3a40a927389e1bd47670c0bb0c2885064c8b9d6123c022e30536e5fa"
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
