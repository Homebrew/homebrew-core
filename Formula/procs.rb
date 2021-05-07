class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.5.tar.gz"
  sha256 "1ab36326af655882c0c291fc78538f9228e238e047e0ceb16d24c6b72498d991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3990cf25d9c3fa83169bb30cb5776e88a4fade5bed5a06374b50ffe5d14679ac"
    sha256 cellar: :any_skip_relocation, big_sur:       "aafca07219f4e6b1fc7281ee7beed8a8e6a55090864598c2c0a115d1310ce6bb"
    sha256 cellar: :any_skip_relocation, catalina:      "8014350b64db9d4b301bcb832c6afc8e1f45d81857a9e5d0cdbb54520a32de71"
    sha256 cellar: :any_skip_relocation, mojave:        "eb13ae0064dfebeeba1c48ff7ce9f20bd5a0a73c4f837bcadcb24c55e4711417"
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
