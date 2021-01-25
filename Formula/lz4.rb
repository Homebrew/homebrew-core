class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.github.io/lz4/"
  url "https://github.com/lz4/lz4/archive/v1.9.3.tar.gz"
  sha256 "030644df4611007ff7dc962d981f390361e6c97a34e5cbc393ddfbe019ffe2c1"
  license "BSD-2-Clause"
  head "https://github.com/lz4/lz4.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "7024d0b6ee857352cbd3138f752496b87fa27252adbc6daefa4a6c64d3e347e5" => :big_sur
    sha256 "1d915415cff308983a50f873db4f0de6acab7b57d65a93ec127c06c824ca0269" => :arm64_big_sur
    sha256 "899aeb12833a982e06013a60aa9b1ee69e3f77f969a5aa2dcec02ad329f369bb" => :catalina
    sha256 "e6adc6da46164495cf129c9e54bd69c6620eb4622a38e403edf1b5f488d044a8" => :mojave
    sha256 "46e99b27c33fd51a4394850be3559ea7b69fc26060ab2095dae315be14aa5e94" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = "testing compression and decompression"
    input_file = testpath/"in"
    input_file.write input
    output_file = testpath/"out"
    system "sh", "-c", "cat #{input_file} | #{bin}/lz4 | #{bin}/lz4 -d > #{output_file}"
    assert_equal output_file.read, input
  end
end
