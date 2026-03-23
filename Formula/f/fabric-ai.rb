class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.441.tar.gz"
  sha256 "936aa5af281b57a8b3f3283153a1e39cb2da08ed7199afa00f8ef1949174df4d"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44f21e61dccfd38cce8254e7130194991d22568c4adef70235642af4cde18f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f21e61dccfd38cce8254e7130194991d22568c4adef70235642af4cde18f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f21e61dccfd38cce8254e7130194991d22568c4adef70235642af4cde18f82"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a7b5909dc7c8ce0c0d8701d4997f93381a11ce1b87dc8c4f572bc417f215fd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbaadcb5f516ff9b5bd67d7580b66a7ade325b16b337bb8897629e78a454e264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bd1a816b2340bcb4f7f48ba4e6fa703bbc45b8cdf86c5903a0889fb1dec02a0"
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
