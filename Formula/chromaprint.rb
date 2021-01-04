class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.0/chromaprint-1.5.0.tar.gz"
  sha256 "573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a"
  license "LGPL-2.1"
  revision 6

  bottle do
    cellar :any
    sha256 "86aea9488123d54e9cab885c19f253061b70f07d2841bdb90fd8e2051211b7b5" => :big_sur
    sha256 "6fcc7d4f57aeba72a414908d4d190bbbc755b50efca3f0b6e709974303078491" => :catalina
    sha256 "42279265906afd2ee3400ba3db790a789dc04327b9fa4a56c744ec33a26aafb6" => :mojave
    sha256 "e3e06be8864eb0bc81ec2b89d1c41a69c4c7609660dbf96b315234d36192c00c" => :high_sierra
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
