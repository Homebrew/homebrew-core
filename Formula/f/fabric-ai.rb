class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.328.tar.gz"
  sha256 "c8ae88e03e57e2e1eeacc0394f2301d5a8bded1b0956d3e27174d435f9e964a5"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "368d365bfd57cceccf861d90b89e34549148bf8f56a1072e8d5084d4322efd5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368d365bfd57cceccf861d90b89e34549148bf8f56a1072e8d5084d4322efd5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "368d365bfd57cceccf861d90b89e34549148bf8f56a1072e8d5084d4322efd5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0c5e2ff381de7bc4ee6bf7efbffb1286d05853421fd9bab4448cfa7e562b6f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62b3971f7ec11421113917cf6d5636915d906a6cea7803e45a93c6aad50fbf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f48a05836f374fe3b357b2c277e9bedf441b282e4c7215945e474b082395510"
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
