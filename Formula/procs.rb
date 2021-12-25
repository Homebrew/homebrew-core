class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.13.tar.gz"
  sha256 "b769ddf1b2faeca4e9fb22e8e0248f5d69b4b88bd51fb37c8510d2e6a8e897d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae85aad18668f04cdb7d2cc385f7b3e420990f946242efad5d94e6fc9b259dc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3be0351b1eb2d661cec7231d60443e9366e923a469051e8e9ff66bd8d7380b66"
    sha256 cellar: :any_skip_relocation, monterey:       "4c16a907b72b5de1d84159280a7b219f59c327cb3e07adaa1757b1751674d3ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "afeea45b4307e0b19df6f9307d64016f8fb6011bd06b1d23ef683e038e2c92ed"
    sha256 cellar: :any_skip_relocation, catalina:       "987385add36adac7011983f1908bbe7b1da27f8714dd933de9f723d7863be9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238c47627d0a624e74ec945c5d270ed8b8d217a4b16d28ece1f662af7a3a1323"
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
