class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.6.2/chromaprint-1.6.2.tar.gz"
  sha256 "d54ada62c16b2db396d3251ec54fc7a58909c163131a1cfcf7fa6407dbc14360"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9446f7a7a9204f250cc483249e06483b947b28997146f44ed41d8ee801fd0d04"
    sha256 cellar: :any, arm64_tahoe:       "0008cd637f81515fd52cb97a589d1c13cbaeea5314561098b6735c176eec47a1"
    sha256 cellar: :any, arm64_sequoia:     "181a34d298b3a98ceb26b6bf93b3089eaafd38544f4038a63767bd8d1b707cbc"
    sha256 cellar: :any, arm64_linux:       "77ba669af47e4175bf717addf5cdb4f7aa66e174d4e4dcdae7b7baeb9302cec8"
    sha256 cellar: :any, x86_64_linux:      "a9df07a75ffbb54c9beae2b9cb8be7d9d70ca17e25b809ab3918d3cb9c1c788b"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  deny_network_access!

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
