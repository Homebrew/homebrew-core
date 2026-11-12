class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.29.3.tar.gz"
  sha256 "6d7343042c072f0065d4357666aa3530a3fce03d79cea7378fe20e816e2b5240"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ee8b2d452d675982672d359fdc610e14cd6468afceb0fa4292e88a645e13c4b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13a958f07cc5e6de1ffecabcc4079d9fb5f9babc7c3454a0dec901eda856c8b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3ee6e92ef49f2e3936c5a0c13f0fca1187a13cb441f2268c8fb026e0e264a59"
    sha256 cellar: :any,                 arm64_linux:       "6779e879b8a5e80d2a7dc02b32c8956424f3e09469930c03eac0b73028623b53"
    sha256 cellar: :any,                 x86_64_linux:      "d7b9480bc9bc9647ea4d790fdaa7998ff8bf663e42f1b3ddc52e440f221589e5"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/leaf.bash" => "leaf"
    fish_completion.install "completions/leaf.fish"
    zsh_completion.install "completions/leaf.zsh" => "_leaf"
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end
