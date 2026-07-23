class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3a9b33e41561f80eaa9252673a1ee1b4857743e2ff7b33079d0b616c772fa981"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42bc610b05790d515b8a43e2c3f27ac9b31aa101f33dcf87b5f424970c692ecf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "359cd15d689c6de88766baf7a390b5fe47c13d605bb9d0e3cf2c76fa84b41492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26e6dbda7b0cf1dd22ca0968088c6319c498f991a78a55ad0eeea5960309e716"
    sha256 cellar: :any_skip_relocation, sonoma:        "8567191973fe7ccf6f1a05a981580708e5b7f0cbac2c234c54c04eb57a437ff8"
    sha256 cellar: :any,                 arm64_linux:   "f8ceba225df3a02e271eb6e9745144c899973d979dad5fbc325fdcfbe0617cb0"
    sha256 cellar: :any,                 x86_64_linux:  "d824e0b16080c900acb3836f6ea3a7c15d8f8a67a4e90811a4071386dd3cc937"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "gix")

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)
  end
end
