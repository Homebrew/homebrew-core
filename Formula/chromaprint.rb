class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.0/chromaprint-1.5.0.tar.gz"
  sha256 "573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a"
  revision 3

  bottle do
    cellar :any
    sha256 "c57daf69b96aa3b77b979629d900cb6bbab96482ecbfb9a4b4262e9e4c869772" => :catalina
    sha256 "1d384f9a97401cd17f7fb653a9b78cc0a4e9cf068e3435f50b8af05f8f523494" => :mojave
    sha256 "c61dd97a1a22666ccdb5e76f2ede3428b9e14b46930b678e523693cb4173b97d" => :high_sierra
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
