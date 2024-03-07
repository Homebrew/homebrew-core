class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "539b88565c775a106063da5cc5148cfdc7e010534f3dbc90cb8f6317d51ca96b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22e8225c03015846ccf8a13476bb6a85844c3dda4de6fa81c6c770d9ad494071"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a34532c7cfafe0d2cb1bc693fc628d090f9d9ee99761842eeb456a96f5b8ac8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e795471d2965482d8093b2a029bc9e136d90d78baff31f5e439c87a5a36adc"
    sha256 cellar: :any_skip_relocation, sonoma:         "819744211e1b19e0b9d103305fc866409ae520193d6c0c6c9874b012176d7dce"
    sha256 cellar: :any_skip_relocation, ventura:        "6c4fbb7056ad35ad0013cde9f0b64c34cd651fda279e012280e1fe1bb455f093"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa8ecbb504b60eceb217118f57a9afee6cdc3132a3fe9c94341ca9f79b99c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4a7a97feb2713a790f16fa77441f01f2a0943460debd1a29633c425d622bf0b"
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
