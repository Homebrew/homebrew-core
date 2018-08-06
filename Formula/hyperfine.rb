class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.2.0.tar.gz"
  sha256 "324ab37890a1cc64680b0e5eae03eebda53b6005166148150a7c82f045e7015b"

  bottle do
    sha256 "355b50d978d6ae1f8bfd5b963e84396b86023ebd96c7b2b1839981f61fb7da9a" => :high_sierra
    sha256 "7d510caac6e35c45b1472279e82b237f3e5058d9691ced30a801ed87b35aabc1" => :sierra
    sha256 "a82d2806e80a0e222f82bde4ea4cd74cd30b9819a4735b064f08ae40ba2e34d9" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
