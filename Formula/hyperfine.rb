class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.8.0.tar.gz"
  sha256 "14de63b44eb4c2c5d6a6f9354acbcff350c9a2ba50b2397de5798c152cc2a029"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a020dade6fe4d70a91868e37d64cb683708e719075d759fe95fe995cacfc567" => :catalina
    sha256 "6d198895f7fbfe5f570bc3815c41affe85a354515a3176afb60af22c56910138" => :mojave
    sha256 "2828ad907f5a4463253c05585dfcc9151d19987eab406e92d78773c7ec7c5e5f" => :high_sierra
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
