class Liblerc < Formula
  desc "Ersi LERC library (Limited Error Raster Compression)"
  homepage "https://github.com/Esri/lerc"
  url "https://github.com/Esri/lerc/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "91431c2b16d0e3de6cbaea188603359f87caed08259a645fd5a3805784ee30a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f504026b3c217a7743fa818cd29f2576eba015765545340eb4dd95690dd548db"
    sha256 cellar: :any,                 arm64_sequoia:  "1f20f8fbf3268c2851793fd8f1215cd7a6f3fb55f97753314fad5fe57aaa678c"
    sha256 cellar: :any,                 arm64_sonoma:   "0850343f6c9467738b9f5bc143d140fababcf53e0bd0cc6ebbe0952e3a524b5b"
    sha256 cellar: :any,                 arm64_ventura:  "bda5945718a4ae8c186d1c0574c70667b95b6e2cf1cd95060fc3a7b4c78a63cb"
    sha256 cellar: :any,                 arm64_monterey: "ac9a9d7025ab1fd8e49d79518ce278bd9c3a08a782478a6eebf793c663e9673d"
    sha256 cellar: :any,                 arm64_big_sur:  "b498cb1e4a46236e877b8497c293f0be9d8c47ee4357b5f12dfd94a22fe5f29b"
    sha256 cellar: :any,                 sonoma:         "cd18579fc472762ec9ceba58ad5b11a46027af4fbb3a9f8dd64c6420aa9b0845"
    sha256 cellar: :any,                 ventura:        "436d533a3de8a6ec1f4a099d9ee816c9a1b01cfcc1b2b933b8f5a1d4e10bcd51"
    sha256 cellar: :any,                 monterey:       "222a3e3fad0f4528161894f262458ec850ce1e8525475b7c3b4e0158f0d3c944"
    sha256 cellar: :any,                 big_sur:        "f3d0aa49310e3fcc3b88c07f8609dc1988990b9f270e3d002947a9a237ca2c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9f777d122d1776bb11be82bb12a18c4cfa17e2b9cc4aa5f8c807b1d16eb1138c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d409346584f40f2fd9aafa46860d7a5668b9c5f42b3de930868cf65daf556d7"
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
