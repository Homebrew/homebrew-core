class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.386.tar.gz"
  sha256 "4c23d30d0ac2081623cabc0d098b13dcf0fa0bea9c4d93a893c63b496202f0a4"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "538db6e2183a40e8d4b66c9e53a932213c79db2f0ed249fef11fe6961d8ef7da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538db6e2183a40e8d4b66c9e53a932213c79db2f0ed249fef11fe6961d8ef7da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "538db6e2183a40e8d4b66c9e53a932213c79db2f0ed249fef11fe6961d8ef7da"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db526c3f23745ded2fa258d89a0848883f43663d666c722a2ea3169b91ea408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc8f30f2c6c63298bef1666f3cc9d8f8b755b0fa2d5b59a11a5bf14047074f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8138713896638912400fa1abff3a263fb8ce6c40a381a21988fffe219d298480"
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
