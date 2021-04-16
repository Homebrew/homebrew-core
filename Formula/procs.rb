class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.4.tar.gz"
  sha256 "30a903374eb888b89cd43bbc19365aa24ef01b3588298ab246085dbe42c8e819"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2faa660438e5d5d6d8291d1e77cf22f8c39cf89d0dd98bab93dbcc89b5b9f38"
    sha256 cellar: :any_skip_relocation, big_sur:       "25764d841a4d9e8bcd94c13fe41cc9d1d7ad0273e7f73950d3a8dae3d5eeb927"
    sha256 cellar: :any_skip_relocation, catalina:      "d55bf5484f2ab55df73710e7e63a46377201dd0f78f0b77ec14cd478d226934c"
    sha256 cellar: :any_skip_relocation, mojave:        "77d97badab934370b5b38f04f6ee9107f316d3884399bdf00df779384dd5b9b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system "#{bin}/procs", "--completion", "bash"
    system "#{bin}/procs", "--completion", "fish"
    system "#{bin}/procs", "--completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
