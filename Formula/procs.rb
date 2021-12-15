class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.12.tar.gz"
  sha256 "ff1a293d84cc0160cc92b4530ee93cedf530796e80130df74b0490c3e884efb6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc4d648830cad4f81af46fa1c7bba6037ab658729c3eb24b5fb99a5059ace235"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e531c49f3bb461d69f38dc4c5b7445f7d4f530be6b2142cb92f717f01c750d0d"
    sha256 cellar: :any_skip_relocation, monterey:       "f41134934fc65691bebeebd7bd391d501576feb1660640256e62c76504d7c843"
    sha256 cellar: :any_skip_relocation, big_sur:        "91d9f6462b39d98d32867d0cd6f7fc05c26580970199e3a85b2891a0f3d76227"
    sha256 cellar: :any_skip_relocation, catalina:       "819e0f92382a4ddc4772f7041b28fddfcd3f4e06646eaa7a54207eb3ca723a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed4ad6083a2e1323a2d48e60b166bb66f26b216f87519c12521f0f23b49c7dc"
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
