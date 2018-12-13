class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.5.0.tar.gz"
  sha256 "d5183611348e696e579dda846cee92b7b78c8ef18c00bfb9b0a62d0a63034823"

  bottle do
    sha256 "79cd73ae731e8d4d663d629449726e8b580a01d442103fc75fb9f8d9e83f8560" => :mojave
    sha256 "d0d942c22352798c33be64cdf1e49796b432f2c78fd0997eba918aacda5348ec" => :high_sierra
    sha256 "1b3c9403f5e436590d9491caeebd5d98aa4032e77afc1bf51a7b2b7b40e3359e" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
