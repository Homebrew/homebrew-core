class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.581.tar.gz"
  sha256 "1498790675bff6638b77dd65bfa082c8558040e9e1f7a46f506d52c72859a24a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    manifest_sha256 "910f3c2a45eb8745afa6fecef2a5891b16fb9cca8b9faed59048b287644a4c8e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a06076ea9e8c2e55fab5fccd876b658aea0f0b8008360ec383b06df129659cb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a06076ea9e8c2e55fab5fccd876b658aea0f0b8008360ec383b06df129659cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a06076ea9e8c2e55fab5fccd876b658aea0f0b8008360ec383b06df129659cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe6f168d79e8608c0f6f06e2a1be16ba88a76461c40c3e4cda2c26f143552487"
    sha256 cellar: :any,                 x86_64_linux:      "a30d4958508cd8f37a7c0a92da3dae13f0c56820934692580400ea43e47a6002"
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
