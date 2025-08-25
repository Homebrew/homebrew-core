class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "159998cff5a52406eb486bf92989d2184dbf6d47d5ec2593b864625defac279b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "601828ea496c7f0c5f6c79b3eaf565491a4a269dcda085dc1fee20bbfa337463"
    sha256 cellar: :any,                 arm64_sonoma:  "1071f0de9b90ca8235582a3a875fbbdd2c14f02310ff2ef681fb10938a7c461d"
    sha256 cellar: :any,                 arm64_ventura: "68101fdd68170e09c18757fe0769a6b1537d907edb19bc771429492fad05da67"
    sha256 cellar: :any,                 sonoma:        "d757b11423bce8ccc892916488ee058621b64dfa95e8dd81cbd5a50723c2bf08"
    sha256 cellar: :any,                 ventura:       "8249288163dfa9e04f174468f93a371935e616ea92875e8ab067350b85df807c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9af1a4f0db6457ea22c8e0bd3743ce924f35752b0f941ea3082d6a9e2bcd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02b684d4aee2f3c88d853edae6a46ebdf3b880c6545010bf4f5602b427cbe30"
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
