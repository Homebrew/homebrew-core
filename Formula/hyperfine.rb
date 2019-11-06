class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.8.0.tar.gz"
  sha256 "14de63b44eb4c2c5d6a6f9354acbcff350c9a2ba50b2397de5798c152cc2a029"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1551c104bcc214f4bd2ec118cf4e19e1a94e79209f01acc4ab6c65b2d3f1d9a1" => :catalina
    sha256 "5e3b8b4a365d4402a159252ef24a2d3de14e776b1d9017f8cd2ba418f1d084c1" => :mojave
    sha256 "c3fa4d6f6a9b3bcba470e87abd653f32bc0baa9b076d0ec15471dfeb1925c059" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
