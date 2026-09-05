class AgentHarness < Formula
  desc "Performance layer for coding agents"
  homepage "https://github.com/TheElephantCoder/agent-harness"
  url "https://github.com/TheElephantCoder/agent-harness/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "bb0c84d8fa75fe401b9292addb030c599b8a49d7212bfabcd982318fb424f67b"
  license "MIT"
  head "https://github.com/TheElephantCoder/agent-harness.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "0.1.1", shell_output("#{bin}/harness --version")
    system bin/"harness", "doctor"
  end
end
