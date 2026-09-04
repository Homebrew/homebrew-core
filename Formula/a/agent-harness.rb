class AgentHarness < Formula
  desc "Performance layer for coding agents - skills, instincts, memory, security, research-first"
  homepage "https://github.com/TheElephantCoder/agent-harness"
  url "https://github.com/TheElephantCoder/agent-harness/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a3da7c25b19d0f64c580b8adc7e1f8c87cad43203f8c97ef95fbaa0956333df5"
  license "MIT"
  head "https://github.com/TheElephantCoder/agent-harness.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.env_script_all_files(libexec/"bin", Language::Node.std_npm_install_args(libexec).last)
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/harness --version")
    system bin/"harness", "doctor"
  end
end
