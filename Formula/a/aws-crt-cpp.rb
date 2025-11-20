class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "1d84d73d5e32e54757e8feb9441c75a6e5f9e5e1dbb4efda588caaeac9fe7acf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "848d30d4dcfd7584d416b39c5f1ff05c199211cd6b856c0f60bba3ac592b262b"
    sha256 cellar: :any,                 arm64_sequoia: "5ad37c218a74b7816f38b20f1d01caed2daca0342ef4e2b8822629b5a6da1e19"
    sha256 cellar: :any,                 arm64_sonoma:  "c37ea084867a34b8c72a2b40bf37d5a31febdaff1b2065a7189a9453e5806571"
    sha256 cellar: :any,                 sonoma:        "6b86166f06dbb4829262dac5f696e34e03ad034675f46bbca6264b371d9ed75d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f391fa02f19bebf49fa30d31e51c20c0bc2ff7c612ff0b048520337644c40a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0e587a764957596398949d719c4c62b57a58c6df4e93cab61218f6a510da4a"
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
