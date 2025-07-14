class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "10182e870dc35df3ab929e25a4c43bb6b8ed860aae70f597fa401cb5b5da3fb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b22679b7c6cfa8c23c09c69c8287ef5b0c450a2a67c17f85a72d292ed6615979"
    sha256 cellar: :any,                 arm64_sonoma:  "e0e7cea17f936c25a8f853db893a4dedb8e98145fedf0cbbd78df52bd5c811fa"
    sha256 cellar: :any,                 arm64_ventura: "efe86a691f7c57ff52adff5eb6d06c7537311538340b03dc57bf4ebd7d20b2d0"
    sha256 cellar: :any,                 sonoma:        "b38ae08eb010eb3641a8c1c855ab8a281b6be8dfe58f21a9ce4eb1ed6063f5e6"
    sha256 cellar: :any,                 ventura:       "29d0c891b8e530b36e83fbb884b799d0fc830f13d9aca010b1336ab0703d9dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb2a210a81b96eb56b80aa5dd19d0ec92f3708b499356f3d840a472b4fc73d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bf0f031238b65c3c910b39805ce286700779d4bcdf8b50d486bf90ea012e429"
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
