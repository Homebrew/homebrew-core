class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.562.tar.gz"
  sha256 "ffd54865e0c1e354cc08d6bc8d903bf142912e95e02f5c278c73f9e96e24fd9a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "449bd8b6cd1beeacd427e16a45dd9baa0394513863d86b24bde347dc84fd604b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "449bd8b6cd1beeacd427e16a45dd9baa0394513863d86b24bde347dc84fd604b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "449bd8b6cd1beeacd427e16a45dd9baa0394513863d86b24bde347dc84fd604b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6510594713071fee46aabce480ed1a40d7014ec4403280ab3e13cb1f8a2508fb"
    sha256 cellar: :any,                 x86_64_linux:      "48a81348008b3d36857651d776756e141071e8915bb0e9f4de90af821310b85c"
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
