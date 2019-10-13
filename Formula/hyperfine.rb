class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.8.0.tar.gz"
  sha256 "14de63b44eb4c2c5d6a6f9354acbcff350c9a2ba50b2397de5798c152cc2a029"

  bottle do
    cellar :any_skip_relocation
    sha256 "d753b680a58114eb21c6c35cdc82d8ab65e8a232f08b131e617fbd0942fc7b45" => :catalina
    sha256 "1e594b60a9a42d58a48d257b4a3bfa9749ee49411109a8e0eadd1518e8765c46" => :mojave
    sha256 "3800230a38043d4e39d6e256c51ad8993d473e0c43aac1831278516c072b1f02" => :high_sierra
    sha256 "178a014e8792930ccf1114f035188e8a894c3688356257178e4bcec1dd008e49" => :sierra
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
