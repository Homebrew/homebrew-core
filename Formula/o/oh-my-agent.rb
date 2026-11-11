class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.40.5.tgz"
  sha256 "3a165559aa7f7b73d8f226e28521a0f30c6cb9099e731237a3049a4d0515e36c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0e25d04656cd254f278829c78095a7a496b1ceacdb9b676d2c6cc5ccabc9d112"
    sha256 cellar: :any, arm64_tahoe:       "6d68859f4470309f5f0559d5ca24a9b0bee7bfd9c375a2bda30ea8f6db48ef57"
    sha256 cellar: :any, arm64_sequoia:     "86c82e1d90e6a1739778cc4387486e5fb91cd32372fe1bc6f75d3839d9309af0"
    sha256 cellar: :any, arm64_linux:       "c41558dd1754c2d4ab1cc6cfcc4b5898b518cd4f7cde9b2d4225d6f73f0a9a78"
    sha256 cellar: :any, x86_64_linux:      "ed00e980661d1c55850d6895c20bbeecfe7705d7d7200bd81ec726405d51eac3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
