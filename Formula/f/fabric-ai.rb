class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.581.tar.gz"
  sha256 "1498790675bff6638b77dd65bfa082c8558040e9e1f7a46f506d52c72859a24a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    manifest_sha256 "c919c09751097cdb0226fe191ff346c616ec37452eec9f10f051075a545d25bc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1123ca475d07fb8de4120bb17e5112f3f527d03b111674569c8c8a2966f2db8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1123ca475d07fb8de4120bb17e5112f3f527d03b111674569c8c8a2966f2db8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1123ca475d07fb8de4120bb17e5112f3f527d03b111674569c8c8a2966f2db8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8867bc9697a700886a7457933ac476608615da44c3d4c06cc44243b43b9ce06a"
    sha256 cellar: :any,                 x86_64_linux:      "69e0bd8a187c186941a0eed03a069820b3dd1e439a33098a67b44620a21574fa"
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
