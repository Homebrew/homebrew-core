class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.561.tar.gz"
  sha256 "55cb5d08b5efaa076c77296166c2f05f0d50575f67a242b62c00d5fe81f5132f"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf55281d871f2b1bedddd2ba7f32e0fce94ff50ba5eb846f725e8d9192be7dbc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf55281d871f2b1bedddd2ba7f32e0fce94ff50ba5eb846f725e8d9192be7dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf55281d871f2b1bedddd2ba7f32e0fce94ff50ba5eb846f725e8d9192be7dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e89c4251b39720da23f430f92bc3a403e68c57b2f60a7490b4eb84f30ee04ef6"
    sha256 cellar: :any,                 x86_64_linux:      "15b90e9e21d2e3f3d1b64a580d98fc67d6a58070ba9c6a1ee6a1e0eb44090eb6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
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
