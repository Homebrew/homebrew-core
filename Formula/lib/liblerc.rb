class Liblerc < Formula
  desc "Esri LERC library (Limited Error Raster Compression)"
  homepage "https://github.com/Esri/lerc"
  url "https://github.com/Esri/lerc/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "f05b24d2368becab9144873878655bb718910631550d4f786262378c16ab94a7"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d21cbef16be89be5460c4fdad546a31aa2d2cc907d2161bb76f127a6dc0a920"
    sha256 cellar: :any,                 arm64_sequoia: "ff8cc036d09c0ce5d2464ad76f353bf46957e4fec0f8c0b05d1b2aa270412cfa"
    sha256 cellar: :any,                 arm64_sonoma:  "c09e34fec6f3dd2f8da22cdedd27ce19c67cd4f97d1251d4b05fbb6dc6549010"
    sha256 cellar: :any,                 sonoma:        "a7c50bd0ab0a08ab6672afb039320277c2a108c6ab57a3eac0c21b8afa9bb040"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f63b22612265d2098e10f4b662a749c4629b4e133ef95c0fe9397247c13a7dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80485b7993bf590f462d552d34c2dafd4911382c91006959171d2bdeede5ddad"
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
