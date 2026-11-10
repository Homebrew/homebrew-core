class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.39.0.tgz"
  sha256 "8c7ab146ca25f2b4126158b659dedf264bd21df6d00ec1a2106ebf33029390bf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fa2e8833495476314c5ae0b03b01008c1e0e7a975c3a517652cde9d1f064bb55"
    sha256 cellar: :any, arm64_tahoe:       "d6fe94e2c16f05f07f58985b522cf935b81f196085d0ee047a3647c1d4391df0"
    sha256 cellar: :any, arm64_sequoia:     "9c9187f00db2e08d802fdd0b397269e6c2af5fe1e0cb8ea59e5736050bb4f2a1"
    sha256 cellar: :any, arm64_linux:       "89e40c81ecc4aff2956be086c68514799453c750ae1eb90cd30e416c3ee68703"
    sha256 cellar: :any, x86_64_linux:      "7a4f831bbf4841c80124ef45fb29ceb69dc7c38ca8fbc484c24f99bb10ef6cbc"
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
