class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.3.0.tgz"
  sha256 "eda84cdcb3c191f909988517b7e0b0c6894886c85ea6af42aeaaaffdee438a1d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2d933e97ca85bd21e61637ce9e829d18068073c031c7acd55bf0c63b4f07c36"
    sha256 cellar: :any, arm64_sequoia: "2366db3892f70aff046643a7e229f33b500b489a86e4a251837701d52e6b3758"
    sha256 cellar: :any, arm64_sonoma:  "2366db3892f70aff046643a7e229f33b500b489a86e4a251837701d52e6b3758"
    sha256 cellar: :any, sonoma:        "3abed76493fd7c6b5ec9b15bb1dd139e87775e9998b7fa45fdc75e7d2d2a88d9"
    sha256 cellar: :any, arm64_linux:   "707ae6ac1f3994866a843424b931f9c6abf846c6fbc2507e82c17700e4e20989"
    sha256 cellar: :any, x86_64_linux:  "39c8cda4e28fc053ae59f323931dc018c847d9debced925e2b65375ff8b6e259"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
