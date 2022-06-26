class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.12.3.tar.gz"
  sha256 "59720db4abdff1878492929b1c015dedff7cdc0ea2352b1360084e3bb4fbff33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e4ab0e810fc0370e7100e39e7d2e6d2a9b2228757dbd168a92d7a81c5c35280"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d490b2e71e5521cf54b65fb0d2775768960b03b18940fd0fd4a87e4d61efa755"
    sha256 cellar: :any_skip_relocation, monterey:       "6ff68d8fd5f0ff9dcb28663f69f5f065bb77db57c588d5576601a80480561bbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f730b63fa1ab1d3cb46c8a7db53d9b3f938b78348c660527f2b6204d7120ff88"
    sha256 cellar: :any_skip_relocation, catalina:       "2b785b3aeb1d570a1d1f15dbbd6c5dbd2752a3ccf45f0427f2bc57c9d88aeea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95bcee2acfd5e1d12975e9faee6a64c398ad81be3f9ef14ecb2000642c2c5b27"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--completion", "bash"
    system bin/"procs", "--completion", "fish"
    system bin/"procs", "--completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
