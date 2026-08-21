class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "62cdc7f5797d33ed42c0919789ed49d00816985fff414d1490dcc705d8a7fead"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b6be5139acd00e53d48f6726a1a2833cb20245c8c01ba69d7c43dd200e74189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14102f29a1cd4947fdca93c7aee0d7b1f94b9d68de3330df781ad3831e2e4b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa5bae4a721642dde0a18873c1ac48ded962b98dc2ce671d13bf7cc32371caa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e40edd2c02487839f1536677b79cf7eff90479c91c4a1e77d49a2328c56beef7"
    sha256 cellar: :any,                 arm64_linux:   "4f7ec508e0ad4428fb15107b242243d25c8ed0b0bfe35e97e750f2c605a5ba9c"
    sha256 cellar: :any,                 x86_64_linux:  "5df5f3c83e853fd91f283d203aeaf5eaf1606ddf6849b5415882b8334163a05b"
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
