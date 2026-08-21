class Liblerc < Formula
  desc "Esri LERC library (Limited Error Raster Compression)"
  homepage "https://github.com/Esri/lerc"
  url "https://github.com/Esri/lerc/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "a1fb593ed1fcb5b38800caf3c4454f872745202e961d00d745e53d81447e17c9"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4bbbcc51f83f769162c44d936642d7c239200f6029e7aed3fe1960d8793a16d"
    sha256 cellar: :any, arm64_sequoia: "7b63dddb160e026085a8e5d44387c30c213b4e13e7ff06398db8cfe833e8584f"
    sha256 cellar: :any, arm64_sonoma:  "28d3a0920443b66baf1f6b17df4ba352169d506198e8f483e4d887e92479ab2c"
    sha256 cellar: :any, sonoma:        "e46b255b2eb7e1463ee166fcee7dc45da3b78c325f5020506c4f90e39e76e863"
    sha256 cellar: :any, arm64_linux:   "9f8118de7abee212c290b4f5047aaa0f9168fc4714b92af95cdb78c0041d88f8"
    sha256 cellar: :any, x86_64_linux:  "3e74e8b4392767d770d87f8547a974aadac9beda1ac20a30d9407370688df4a4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <Lerc_c_api.h>
      #include <Lerc_types.h>
      int main() {
        const int infoArrSize = (int)LercNS::InfoArrOrder::_last;
        const int dataRangeArrSize = (int)LercNS::DataRangeArrOrder::_last;
        lerc_status hr(0);

        return 0 ;
      }
    CPP

    system ENV.cxx, "test.cc", "-std=gnu++17",
                    "-I#{include}",
                    "-L#{lib}",
                    "-lLerc",
                    "-o", "test_liblerc"

    assert_empty shell_output("./test_liblerc")
  end
end
