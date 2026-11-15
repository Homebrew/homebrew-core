class Liblerc < Formula
  desc "Esri LERC library (Limited Error Raster Compression)"
  homepage "https://github.com/Esri/lerc"
  url "https://github.com/Esri/lerc/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "28d74992e0bc0f13ecdda1dd9ca3b40b1a87009369b9ec5a599853f6f311fee7"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1cd5dd2e502dac355e2e57c4efd0dd31597846b79830c7972359b8375f30e0a0"
    sha256 cellar: :any, arm64_tahoe:       "b61635f91bd88667aa386fc6bbb67df1af289d51daec935a00f89159c3548841"
    sha256 cellar: :any, arm64_sequoia:     "cff8a14998073c9dd1a91f291258e0488e0d5670db80a8e2049d1c0e7e6f7ccd"
    sha256 cellar: :any, arm64_linux:       "20f9c6cf1d8ad208171e7a4658e12c6cbb6cb5dd606fbf0ed6bbcc29822973fb"
    sha256 cellar: :any, x86_64_linux:      "315d93e84865e319954ad3b2c849cf5dc263c52f6bbbf209772be808784fe34f"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
