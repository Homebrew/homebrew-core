class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.42.3.tar.gz"
  sha256 "fcd6a5bc5c91042494801235c9699eb63c47e5ef821228a1eb10e3ad38974091"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cae4c058e79d4773a464222c80b97c49b69dbea8c8c039604e808a65ccf0ced4"
    sha256 cellar: :any, arm64_sequoia: "a3e895ec981d6b673929cfd5b4fdd1d8ca9fd8dd052d1a9feef23811c5df174c"
    sha256 cellar: :any, arm64_sonoma:  "9d629636cdc0b71b1c1ba08b01e56283a019b3d3f67857a437b08884c455627f"
    sha256 cellar: :any, sonoma:        "23206cf7dc962d6d09bbda39232a88c043e558fe5633ea7a9a146e5898c2158d"
    sha256 cellar: :any, arm64_linux:   "9b1984507c488361ef437f9689368ea690246599c850f83ff61fbcd347552793"
    sha256 cellar: :any, x86_64_linux:  "45de0b5def0c645de8d8c4666b12ad02855ccf69eb8579c4208b858cae4a4ea2"
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
