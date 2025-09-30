class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.21.5.tar.gz"
  sha256 "7fdd3f100352ad6b054a84f7be82566d5f2121a8bcb56bf141db7cdc9450f572"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69e01b3734d461f6e4463f7baefd40f1f30ddd42fadbef8792b57affdc74baa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69e01b3734d461f6e4463f7baefd40f1f30ddd42fadbef8792b57affdc74baa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69e01b3734d461f6e4463f7baefd40f1f30ddd42fadbef8792b57affdc74baa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d48223e3c6f6b4c9c5b02483399a6e3d7e108f6a036adbdd91f6ee5500f2c385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce2338f2cc5dd3d54659518e9b03d3557343b24dd323703eb9628e3ed00f8d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", "completion", shells: [:zsh, :bash, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
