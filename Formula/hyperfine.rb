class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.7.0.tar.gz"
  sha256 "d936aab473775e76c3a749828054e3f7d42e3909e8b0f56f99ecf6aa169a9bd3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae46a59b81f0c2d89955d2c2f4add6c1aba0c1beceb59076a6b1a356ccbd6572" => :mojave
    sha256 "b972f3144fa116ae1698e8479ab6cc76ab9fc2a907423e8bd88ad260425b6e06" => :high_sierra
    sha256 "dc3dd6d6a5d5c5001f66690f54fe0ba416ce2e9cafc6a914108d859d866af502" => :sierra
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
