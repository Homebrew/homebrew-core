class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.43.5.tar.gz"
  sha256 "8c83897fb827527b67377f08a5b349576c50add2406fa1ff372cf2dd16fc00f4"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "88db81839670dd39027495205f1946ab7e23e332e965f19ca4e6c7a5bb94ac0f"
    sha256 cellar: :any, arm64_sequoia: "135991a9cbc3f97dd778ede25a8fffa6925b128fe7cc3db572e4592b1efa3cc7"
    sha256 cellar: :any, arm64_sonoma:  "0baf3eaad4a20bd12cce0da95a152edaf98a625a24677d95035686bf7ab1a287"
    sha256 cellar: :any, sonoma:        "41a3b98914346a02c5d060fdb6b61718aaeb7dcd5267cc27c82f43f6939358f1"
    sha256 cellar: :any, arm64_linux:   "99d47c6d0a0b40312031ee09dbc3cbbe38f0850622c3f8ab636ad9b031383ce2"
    sha256 cellar: :any, x86_64_linux:  "737a198f593bbf7e9cc374eb7bad2c97b00136e277cc4d10445e293cd16974d3"
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
      -DCMAKE_MODULE_PATH=#{formula_opt_lib("aws-c-common")}/cmake
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
