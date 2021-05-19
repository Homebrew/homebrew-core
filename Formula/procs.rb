class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.7.tar.gz"
  sha256 "39758bb7070e8c3d2490a0ef5cad2cfaabf2e69be0c3a5e90c386507fe6e6970"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f99791c8c27ea052c4fef0cbbf171cf38c67d0cce8a0c3170e07549c41ba36c"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc8857ce6fc3218dc6dfd981e0925897ae226c26f216c7901845cc2616917e7d"
    sha256 cellar: :any_skip_relocation, catalina:      "6a652f89490701126909c580d5283929afb8737fe9e16d21a7d632b9f97e09da"
    sha256 cellar: :any_skip_relocation, mojave:        "625fb26a631a2e2693e187beea20521ff6fc17be719b80be7366226f6bd4162e"
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
