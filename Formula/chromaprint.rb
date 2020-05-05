class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.0/chromaprint-1.5.0.tar.gz"
  sha256 "573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a"
  revision 1

  bottle do
    cellar :any
    sha256 "a708aa303446e28fb91b940714eef17db93dbbdb7e164b6623762c80829bd10f" => :catalina
    sha256 "7459da9ccc704fe6033e76da92c7c26df0da349caf7c2f18f5b987d5991378a9" => :mojave
    sha256 "a7c304145c854c03a8016d8ec9bd48d5d967d786eb2e37013eaa07e75085a9aa" => :high_sierra
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
