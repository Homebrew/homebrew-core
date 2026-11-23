class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.582.tar.gz"
  sha256 "17b34d2799b185cbf3546f791ac3bef69ba84bde580bfa77fe9e5899f4a0932c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    manifest_sha256 "6e786ef1438e25a8ea77a144032c77b853c2eff66886eabad8e4f32fd92b3417"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a47a9b3aa1b8ce9756c7b3c5f35cf7e8304344f56b93980f84eaa09ab6300d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a47a9b3aa1b8ce9756c7b3c5f35cf7e8304344f56b93980f84eaa09ab6300d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a47a9b3aa1b8ce9756c7b3c5f35cf7e8304344f56b93980f84eaa09ab6300d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "205605230df5b1b797cd64427fb450d0a5c3598e4158bfa573cd1ab38d5af821"
    sha256 cellar: :any,                 x86_64_linux:      "d8094cc6f654e6685b798aeaab36569bb15b952c8cc26cdc26ec2e98d2ace540"
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
