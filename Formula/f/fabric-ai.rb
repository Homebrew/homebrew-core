class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.380.tar.gz"
  sha256 "6b93552efac3bb95895573dae101f0838206554ea4d53906a3e3ea97cff58b68"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6f0806a1b0b325bff8216502f05e2622c9a547a8893724dea4e79c723c6960b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f0806a1b0b325bff8216502f05e2622c9a547a8893724dea4e79c723c6960b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f0806a1b0b325bff8216502f05e2622c9a547a8893724dea4e79c723c6960b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca8bbaf6aad4136c9f59220bd63fd289839fdbe008e5e71b3561d8f34a52142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f7dba7881f28e3b30dc2cf9f51dbee79f9d8bf07eb300240d7d6a5b8a6c4d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "362c9febcd173cd29e2eb2be0caa5665a8569673009a8bfe059a63aab2cbe0ee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
