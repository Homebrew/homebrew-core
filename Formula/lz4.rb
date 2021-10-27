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
    sha256 cellar: :any,                 arm64_monterey: "d222923849a6fefd391ab6705f1468c10d287c08ab9c4b5053a18a552139e262"
    sha256 cellar: :any,                 arm64_big_sur:  "1d915415cff308983a50f873db4f0de6acab7b57d65a93ec127c06c824ca0269"
    sha256 cellar: :any,                 monterey:       "5ed09cfe61aa92ae7e28a5a9acf0dfddd5e327f8b2995d1bbe96f63d79fd4f54"
    sha256 cellar: :any,                 big_sur:        "7024d0b6ee857352cbd3138f752496b87fa27252adbc6daefa4a6c64d3e347e5"
    sha256 cellar: :any,                 catalina:       "899aeb12833a982e06013a60aa9b1ee69e3f77f969a5aa2dcec02ad329f369bb"
    sha256 cellar: :any,                 mojave:         "e6adc6da46164495cf129c9e54bd69c6620eb4622a38e403edf1b5f488d044a8"
    sha256 cellar: :any,                 high_sierra:    "46e99b27c33fd51a4394850be3559ea7b69fc26060ab2095dae315be14aa5e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "902257ec34dd2beebcf22bb68c9ccd179008c2ba8d725436c3c5cd5a503e4665"
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
