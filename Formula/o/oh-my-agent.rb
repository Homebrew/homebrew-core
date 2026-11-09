class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.38.1.tgz"
  sha256 "29f035f7afc31f2931055bd042a1d291a118cc64b41b10d395e2e47121ede04b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bf386e37e29ac4f1f613fb390feab7a6f6f7b1bc6d95c0520993638511cf4e6b"
    sha256 cellar: :any, arm64_tahoe:       "1bc04844364f3a16d1ba16075db03033425bc9106cbca5848ae1100570326f5b"
    sha256 cellar: :any, arm64_sequoia:     "67e2d31df19d17575a78b626575317d502f606521f8704a13a28ce357ca08f7c"
    sha256 cellar: :any, arm64_linux:       "48f8bc3b0e1f949f1c71829b41aeb82adbf25c4aee1532ac0c0e31d9383dfa46"
    sha256 cellar: :any, x86_64_linux:      "3f15fc4a98f5fc93f13177b452980496bd22dbcdfd1c89f45c2f043558ad03c7"
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
