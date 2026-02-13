class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.403.tar.gz"
  sha256 "1cb99dab605df0400c69ca921f1f34a8d0a64b97e92d2cd04c1cba5cc8fcdfba"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79c02ee77d183cd45496db5f094ab1c9f69dbd213ba16c43615785114781dd55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79c02ee77d183cd45496db5f094ab1c9f69dbd213ba16c43615785114781dd55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79c02ee77d183cd45496db5f094ab1c9f69dbd213ba16c43615785114781dd55"
    sha256 cellar: :any_skip_relocation, sonoma:        "81de10b2ba4accbc3ed7fdb97e7ba2a188477915bf1108c3be092a32261dd601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c51d588d13db6503402dfa0b04338f87cdfe1bfb32321d9d23ec6c049accdcd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f5fae8ce1aeba4eb2e2ff94f85a903445a769c9d1a065919272042842535380"
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
