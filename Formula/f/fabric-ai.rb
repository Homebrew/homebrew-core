class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.452.tar.gz"
  sha256 "8a2e720d5ab42af22f296b9e1e4189c3b23f3c3f3e5561d9760d76c19ddfc781"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd68b6cfadca5e7df4a30b4452724be1603b7b9fd1614ef1d2ca385d75693a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd68b6cfadca5e7df4a30b4452724be1603b7b9fd1614ef1d2ca385d75693a14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd68b6cfadca5e7df4a30b4452724be1603b7b9fd1614ef1d2ca385d75693a14"
    sha256 cellar: :any_skip_relocation, sonoma:        "490673d875f79548f1ecb324682cc2cf043d59b01d043454775fabdd304fc934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "775a2b1bd201486fbb0ea307623e6dbd93aa26e193746d1fd9d6c6043146db5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd2e80c411f24d32066568f275d52f3314dc45149fdcdb00ffd08abcf430df2"
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
