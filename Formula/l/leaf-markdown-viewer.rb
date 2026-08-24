class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.28.0.tar.gz"
  sha256 "fefed64cdcb4c44893ba531df28471ac27eed5741e382ccfe82ab3e87729b343"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b41b69b867f66f5d0866422047dd6d7ba70ce16964dd3479dc368b103ed6ed92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "185320094df2c64f2a6ecffb03f1c29f0577e87ca0de3028d4383f04a1e7b2d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd104818bf4e3ba4538826705c17fa1bf26a83450293857249823070abde4ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "297b9c6421a43a96d702090ba3e7517cc43af18bcd179dfa71a0330f6125af87"
    sha256 cellar: :any,                 arm64_linux:   "31ef0cf4dd7326654fdb186a20c39c3ab2f8b7a35826fc49176d3600be099d9c"
    sha256 cellar: :any,                 x86_64_linux:  "cc9baf401bbee3d53580b31f94595d38d803bba02d6e78f9adae175f49785d25"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end
