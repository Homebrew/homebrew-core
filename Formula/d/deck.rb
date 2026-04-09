class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "6206fc6549e4229d4827b74675ba923c04d52de580dfb500ba9c06d3e87cb2fa"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba6ce0cd4ae42207058a30c5a8273350f1f431938ab139a3313b0da36b9b9ec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba6ce0cd4ae42207058a30c5a8273350f1f431938ab139a3313b0da36b9b9ec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6ce0cd4ae42207058a30c5a8273350f1f431938ab139a3313b0da36b9b9ec4"
    sha256 cellar: :any_skip_relocation, sonoma:        "835666444a10444c0b31210aafefd17ba7c5cd3467a3f1bd13bae4baa5c5a1fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e56ccfe7540f9fe2ce7496c630a36ece3255c56eded5e9270ef5c9e272002ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89c9ad69f26cd141939672e0b9ea8e89c5914e7ca90cacadf48b989712193b09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
