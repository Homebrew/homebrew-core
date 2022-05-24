class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/v0.6.4.tar.gz"
  sha256 "4e2f15e4a0f7bd31e33f1c423e3120318e13de1b6800ba673037e38498b3a423"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "150f80c5d2cb16d491b4bc445aae8e1577153a5a0dceab8b0afde845b49ae034"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "730ceac5fb901e950ddeb35c32d3122f71eb029dedd77970f728da1af0237942"
    sha256 cellar: :any_skip_relocation, monterey:       "dd1d8d898b78b22485744f6a38f106a486200aeb9e527fc6c815b48e916f4cc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d266fffd350d3b812bd5fd88b82fbb5caccad92c9e322686bb5c15925f7727fa"
    sha256 cellar: :any_skip_relocation, catalina:       "80847b910d7c23a5c32cd4351a512212622285dddd2bb0249859da9a790c9700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0b74f2f5000cba2c4b90cef89fe3ce9877fc3eee854f808cb000b054aa3235"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/code-minimap.bash"
    fish_completion.install "completions/fish/code-minimap.fish"
    zsh_completion.install  "completions/zsh/_code-minimap"
  end

  test do
    (testpath/"test.txt").write("hello world")
    assert_equal "⠉⠉⠉⠉⠉⠁\n", shell_output("#{bin}/code-minimap #{testpath}/test.txt")
  end
end
