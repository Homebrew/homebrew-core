class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "b73c702e93e9e29f9b57faf497e812a94edb773e2f7d67d7b0481b03464f1b24"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c26b3c89fd7ab7c9c495176fbe53c0b3fa92c6f8d5d739dcc9a630be0864007e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03bb0a433e09cbe63071b66a53b2b640c4896a389becb90bc5c27c7feba1519c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d43c7d84ef671adfab02117702b56613d9ee7b41f8dab7f199e4b5addc0c56f0"
    sha256 cellar: :any,                 arm64_linux:   "64d6be756227a554d791bf52d8dd5899eace60472841dab6377257781894c529"
    sha256 cellar: :any,                 x86_64_linux:  "beea1ce49b7c7c843c5893e276dbd1eda58bc12f4a37ec3a79498bffd333edd4"
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
