class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.14.3.tar.gz"
  sha256 "a3012bba984faddcf8da2a72d21eb9a7e9be8d5d86a387d321987743b0080a8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ce6b11cc1482de7452e4cb4dd81d2ca5725c58e1a6e7e32ee9a99c296c8f614"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4adf655c699a6f0e8221808c7b4829f7b1e89afc8718a340e967879c31a327b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6d5ab5af2cf2b964c3d0bd3a6193ceb981a82f164f865df7a8662fdd924e254"
    sha256 cellar: :any_skip_relocation, sonoma:         "90a946992e961a70f44a2dddec0c8abe5cb9924a929c88fcd226cb6cb69ba1a7"
    sha256 cellar: :any_skip_relocation, ventura:        "c8018fe2d236cc17659feffdfe2c35b524dcc3c091e91519fe799cb9fd6cf288"
    sha256 cellar: :any_skip_relocation, monterey:       "0c5c6348bb568a8f0cea24d83b17c5322e4eec25841d90079deba715c612019e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd1f501e52c0fec6183905bfb910df6f2737e198d5abd78ae67fb77fc6e666b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--gen-completion", "bash"
    system bin/"procs", "--gen-completion", "fish"
    system bin/"procs", "--gen-completion", "zsh"
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
