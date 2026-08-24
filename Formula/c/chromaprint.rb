class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.6.1/chromaprint-1.6.1.tar.gz"
  sha256 "3368805af0ee47b9df74df10b5001a44569e01df2844dab520031720dde9ad23"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4bbfd1fff49b1e3f602e4c22fc57432e3235ed93c931d18f6e16c9e8f5ac61a8"
    sha256 cellar: :any, arm64_sequoia: "2707ad3b5485c678f3f291c02ab621d30771c89509b1df446458e49610b3f197"
    sha256 cellar: :any, arm64_sonoma:  "6ec11502595524570391b3afbd99910216272d8d1444e24214b1570d0c34936d"
    sha256 cellar: :any, sonoma:        "454684649fd41eace479350f18b1fc2602f4e08747e74f5a0c187a7dd29fec9d"
    sha256 cellar: :any, arm64_linux:   "1c468590de3d8df81fe2a37748cfaa56a0f972bb01ed86a6bf9a1208bd2463ec"
    sha256 cellar: :any, x86_64_linux:  "59606ff7903edb508f2b2db6f48e8e7b76943a9010940274db833515c18a5ae9"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
