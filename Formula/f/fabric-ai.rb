class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.329.tar.gz"
  sha256 "e1113138c1ef3ead40eecc7b596a6c94cb5f9d8dc7eca18863a0c25f573515ac"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b22fd4aa1ec59a3b533723ab83558bdcbddefe3bc65fb264e8e646b9432248d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b22fd4aa1ec59a3b533723ab83558bdcbddefe3bc65fb264e8e646b9432248d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b22fd4aa1ec59a3b533723ab83558bdcbddefe3bc65fb264e8e646b9432248d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0de6e8f6b7c891e60de1e9f75aa19111a2c2f2933b29330d14cbfeda5186500b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ff021ecaa98ca4d7e08d2e6c77ace7a41aad8cbdb142fdd4f00cf5966380b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee8da092084247cd9d3c7f33a9b5d49f2380d3657b55e3ad40509a00c4800ad8"
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
