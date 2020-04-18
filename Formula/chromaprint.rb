class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.0/chromaprint-1.5.0.tar.gz"
  sha256 "573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a"

  bottle do
    cellar :any
    sha256 "c4518a79354d83e6733b1bc6601ea4b4b2d4c91de26d9d1188f601747da32aaa" => :catalina
    sha256 "7afdff7baf8753f49e72c240bb451e330794786a8f50c61042450c734b26c417" => :mojave
    sha256 "9db0149f48ebe7915273098de736aa5284d482c5d2aa7597a10fe2fe9aae3c27" => :high_sierra
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
