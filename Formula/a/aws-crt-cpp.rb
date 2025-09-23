class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "27ca720e2a9f2dfa4c2d3dc73813ebf5749a2a52c8f97b8a402173a8d6e93560"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4568e422d4ea00b88c7d3d4ab414e7523c6929eb3b61bd39c3466262c831702e"
    sha256 cellar: :any,                 arm64_sequoia: "a22bb851768d32c3bace3280e599961e6b73e330443dc458d0b2e7ae0997dd3c"
    sha256 cellar: :any,                 arm64_sonoma:  "a3e4d9765dbbaaf3140f159de51d24014ada36693daee588d74fbeae7bf62252"
    sha256 cellar: :any,                 arm64_ventura: "0a43440df5f61d50a5702a738e87085c0e9bad5226cfab023241d29926290dce"
    sha256 cellar: :any,                 sonoma:        "64b5c829456cb9ac7ac512a60e7ef0f620a6a5cd0224f3661a07d3f7b8e39f23"
    sha256 cellar: :any,                 ventura:       "d96e16739dbf33e462b44a15822623ced780e8c5691ad870a6e2b1b5e9696d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91852501df5626a7dddaa7be5c39af095948e62604b4212801f27f98f5edff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "919d314d878d4b033c4d42bf62ec33d45d749750c67c94a507f7db008b359d26"
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
