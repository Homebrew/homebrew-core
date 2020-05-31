class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.0/chromaprint-1.5.0.tar.gz"
  sha256 "573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a"
  revision 2

  bottle do
    cellar :any
    sha256 "121ac6101fdf7d1992c1c2afc3d8721623d7de4844222a5c83df7403b1266ae6" => :catalina
    sha256 "1e69c1e63e873f9356a11750e3d5c9ef56bc9f3fa9b28ace2336c6dd01c40d2b" => :mojave
    sha256 "5c2cacb98a8b15a35b194afabcd52d34969fe53794e5bea17cf38948eeb147f1" => :high_sierra
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
