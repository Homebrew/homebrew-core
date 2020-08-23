class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.0/chromaprint-1.5.0.tar.gz"
  sha256 "573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a"
  license "LGPL-2.1"
  revision 3

  bottle do
    cellar :any
    sha256 "8693666d997e651672c56e619fb9a024d7f839748625cf481028600010f37ab3" => :catalina
    sha256 "eebfcab3bf0e6534a89b8a69c2cfa3d89b4c4f6114351e8cc3a368c4220d31b5" => :mojave
    sha256 "f47fb0b6d7cb0f7b6f974a8ec2f85c9c1afe1cbb553a87dbf0c47742f5db7e72" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  def install
    system "cmake", "-DCMAKE_BUILD_TYPE=Release", "-DBUILD_TOOLS=ON", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
