class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "c83f9915333b6052f5a5ad1920405a5922a3fbf4732021f98dabc240cc1037d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c154cf10b423d417e9d840783d36e5906c7c941d8e88e125123d709b38573e1"
    sha256 cellar: :any,                 arm64_sonoma:  "0f51b916897fcaa35992cf45c799772ed22384a0771877220237d046892b3390"
    sha256 cellar: :any,                 arm64_ventura: "9c63afed47824640b08e380e06dae98bda2de7bd7c75b07d971fbbb54ed63618"
    sha256 cellar: :any,                 sonoma:        "5a6d967e225ebb5817a5caba06daf84f8380415bff543e77a83d498fcd23888b"
    sha256 cellar: :any,                 ventura:       "a4cc25a257543e964495fee9bb62291a8fd1173e4902916626654b9877c8e31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d2eb45cc1351690ce4ad8b4f73850e6a2692bf6d04d74c695165c390b8cebe"
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
