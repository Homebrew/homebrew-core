class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.2/chromaprint-1.4.2.tar.gz"
  sha256 "989609a7e841dd75b34ee793bd1d049ce99a8f0d444b3cea39d57c3e5d26b4d4"
  revision 1
  head "https://github.com/acoustid/chromaprint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3a2316c7cedb13dac47582732166a1be94895398741d45190daaf64a740c307" => :sierra
    sha256 "b6d54f06b28a2d2d9868ee5977ff4f8fb65a7356e0aa9d76b299850642f8e72d" => :el_capitan
    sha256 "e93bfcd661dc4b27765ea083585776e53a440343268d1a4a0c1cbdfb60698126" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg" => :recommended

  def install
    options = std_cmake_args.dup
    options << "-DBUILD_TOOLS=ON" if build.with?("ffmpeg")
    system "cmake", ".", *options
    system "make", "install"
  end

  test do
    if build.with?("ffmpeg")
      out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
      assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
    end
  end
end
