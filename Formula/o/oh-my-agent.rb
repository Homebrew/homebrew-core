class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.41.1.tgz"
  sha256 "1eb699fed9fa549f537cbe782c35c86f3815814e30e778e36f531f8dc9505448"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eef8a525125ee0146fbe28bb2587c58cb5402f9e5f749dcd64331887d79d84b1"
    sha256 cellar: :any, arm64_tahoe:       "78be6f5b05f4109978e59b4e823a64c5360cfa21eeca7078d50c689de2ee5e9d"
    sha256 cellar: :any, arm64_sequoia:     "06eb588b88a44cb7ad64b59032f859034c241b89312ac867366b66e83c478853"
    sha256 cellar: :any, arm64_linux:       "a6d129448017ee3b60183f7bd7ac5e823c7c00ffcbe423fa6299a8135226a146"
    sha256 cellar: :any, x86_64_linux:      "1dd9ea0400ffe059239bc3d69849074f0975ba3de29f7de0b34cdc91787c5506"
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
