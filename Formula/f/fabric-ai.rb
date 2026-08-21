class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.470.tar.gz"
  sha256 "bd632fc8681767e76ae86f0fe09401decd7b6d093ea9ecc8171240bc78196285"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1746772ff8001e14f7252e95fad53330464006cea34624082e51189a352ce450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1746772ff8001e14f7252e95fad53330464006cea34624082e51189a352ce450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1746772ff8001e14f7252e95fad53330464006cea34624082e51189a352ce450"
    sha256 cellar: :any_skip_relocation, sonoma:        "d282243ee0480a6e0abeb3f0bf2fc3d52869de1ab90a9084b7d8fe4a63277c18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca3c0772d2401b4dbb6377c98debf55a7003e29e53eb60abca87610d475f9447"
    sha256 cellar: :any,                 x86_64_linux:  "35bd607d210d40f89cbe45c81b1b01a6ec49fcb72113f7fd9b06496b67964a38"
  end

  depends_on "go" => :build

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
