class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.29.3.tar.gz"
  sha256 "6d7343042c072f0065d4357666aa3530a3fce03d79cea7378fe20e816e2b5240"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "123d68b3d016cf3b7b0c553ea854f695f177f4f6bc986e68b182b6d0ee026fca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a601133856ad253ed32fc8a590b061ce1e5a7d3b5bbaee7a9e6eb4877f0bd051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d3c7477a285cc58660d267e72ba2c7315bd46c6c822c072802a977f7216cd11"
    sha256 cellar: :any,                 arm64_linux:       "85a3b5693c58dd62b5a82da12cf87dbdbfd68273e508705e257ee50638569a32"
    sha256 cellar: :any,                 x86_64_linux:      "c67016049fe41ff5e5196f5d08e1df2902b2e82c3bb72fd42e9932749af3c027"
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
