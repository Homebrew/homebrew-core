class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.451.tar.gz"
  sha256 "eef95b2d0d9b0c39e4c17900525b4beb75e15dd0149dbf8f2283be17f0eec043"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e070a959198ef4e87a655557b2b91037cee97b2a825abfbf5c4b60c894a58f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e070a959198ef4e87a655557b2b91037cee97b2a825abfbf5c4b60c894a58f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e070a959198ef4e87a655557b2b91037cee97b2a825abfbf5c4b60c894a58f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "215ce30c8fac4f032bc6c1d7fddbbbd8aeb02bd9b242775497dc1ad8cb62e87b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fecea2e07225e164e7b58cefcc0125bb75c0e9794cb2f50a8df5a751abe229a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d18beb660494af3b93f0ac5d1bf42fe57fc34d2d64efa1f4cfdf0e6a9774828"
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
