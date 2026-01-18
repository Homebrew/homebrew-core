class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.382.tar.gz"
  sha256 "221a9ac016cec8089852a6a87ee3f4c4fdbe578931b7196b4da9f71344ac9030"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c75f470f5384d19dfd840f5db97418e63e429d83f8879acf6480e6456496d108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75f470f5384d19dfd840f5db97418e63e429d83f8879acf6480e6456496d108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c75f470f5384d19dfd840f5db97418e63e429d83f8879acf6480e6456496d108"
    sha256 cellar: :any_skip_relocation, sonoma:        "db7702751e18b4ed8569029d5987ce235cb8af9fb3f3e99a45b6ce1c9135aa83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "031dd9a62abcbf108641ad4c90f37f723c563b99a3e5c32e080245bf863f45b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "124da39b32a8538d48a039b92a0ccb9bf7ab0cc7fbdd52bbe1517527173482c9"
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
