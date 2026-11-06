class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.36.0.tgz"
  sha256 "58a7e2333e586cefe83c6778c9162f9e420fb9e77486f1cdac749150179c5773"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "873e6fb58eba7a2b5b289e8bd7d5c5c6dce4ae3653e2501b2a74778738b3c1b8"
    sha256 cellar: :any, arm64_tahoe:       "6dddd181c2a81e701ca71458fc3bbe30f20e8855066fb4dccdaa3f06d518403e"
    sha256 cellar: :any, arm64_sequoia:     "849c62ac687d0a4721869f6140d22c19b54590d34d20c5a0e3b356bd23150960"
    sha256 cellar: :any, arm64_linux:       "b17e0e49ad32b657d9cf6abdac02ba9340b0d1af146ef021fe50efe7cccb70ae"
    sha256 cellar: :any, x86_64_linux:      "6af34616b0d87f82ff2196fa8782e61138b784a4f93d7659908483f339484d41"
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
