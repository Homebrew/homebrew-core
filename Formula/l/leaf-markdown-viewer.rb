class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.29.1.tar.gz"
  sha256 "20c7c3f2ae80e960f0b5a894b2ff1c5ba190f21c7a4c1339e10c1df9e3b134a2"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "758d8e973fde8c2ded711656c9982092bb62195685f85a2804b965488bd91ac9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70bec9171c430f271e46bd4c95f2eadb50b711b2e578d064bfe143be31fee921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edb16a64a66c4adcc3339303bfc2db83691a2c0b7d040ad28824a97c0c7e558c"
    sha256 cellar: :any,                 arm64_linux:       "1c72802d7cda8ac26bfd1a7e2dfd192e58a1b03ffddeeac01cb098deabf7ef4d"
    sha256 cellar: :any,                 x86_64_linux:      "31df8e5f43660ad3352bac797f0fc91b952b045bcb2955b5a12652377b361d46"
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
