class Liblerc < Formula
  desc "Esri LERC library (Limited Error Raster Compression)"
  homepage "https://github.com/Esri/lerc"
  url "https://github.com/Esri/lerc/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "fe2860e10635166cd9f2144e429ec6b870d471e9957f5812ba2da0973770b022"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a46cde03fc483da99418ed8f3bc3d66653a5d62c0621a6ad3fb4d2514e896855"
    sha256 cellar: :any, arm64_sequoia: "04c1d8bc2f8bd71d7b5704379b113087cb9001112880a89560a57fa8aa56f866"
    sha256 cellar: :any, arm64_sonoma:  "b0406391b6e874bb63796cba51f91cbdda04a6bf872a6363f027fe4ad7d26444"
    sha256 cellar: :any, sonoma:        "546eb36a9cafb24e0272f6cd9eb578a311c4b8cce5f8598d1f2aa0a7fdd76c40"
    sha256 cellar: :any, arm64_linux:   "53633c21093e841c836bb7b1f1036f5e8b329ca9d0200e183c94aed5dc16b8cb"
    sha256 cellar: :any, x86_64_linux:  "0974e70063438ef16ad9340bdfe1a4efbd860aa49a27389e1c528c11106fb517"
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
