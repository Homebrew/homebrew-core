class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.445.tar.gz"
  sha256 "2816d4cd3da19e3f5776666aedcbcc26b666da1d1869fc33cd24d97d8c69ef75"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be7052b902ae8ebd6439bb67fe4378d5ccffbab70999b97c64ba760646e465fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be7052b902ae8ebd6439bb67fe4378d5ccffbab70999b97c64ba760646e465fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7052b902ae8ebd6439bb67fe4378d5ccffbab70999b97c64ba760646e465fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9801de82e082e3105609822503e23ae8f7466ff20448e7c90faaf99f52b5591f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b410d7906aeab188f65fa9d26200e48a1d319c6bfd4f9351c4ef1ef9329d24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9532fa720250d1acc186673b74c2d1b8b15ce5626cde52dd06b34521857b477a"
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
