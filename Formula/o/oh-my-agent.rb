class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.12.1.tgz"
  sha256 "ce5b411cef0f01c3475e6e8cbac279e7ae281b3121b2102d66977a26028a8954"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55e0e8a7d107b6ed702b2d9010a82576f773642f42b6cb7830504be9db5f4c3b"
    sha256 cellar: :any,                 arm64_sequoia: "4aecbebcb0c38c793b21ade3e9ea256c12892f65156f62ef0aabe42d0efa5222"
    sha256 cellar: :any,                 arm64_sonoma:  "4aecbebcb0c38c793b21ade3e9ea256c12892f65156f62ef0aabe42d0efa5222"
    sha256 cellar: :any,                 sonoma:        "c7b1c69272bd50b6e0da2cce3ce055486033daeb69637dac6a47139d60de65b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157f7c05cd9e2d030f0fad6a7f48a319b59d22cc23f8e79acf5311068729c452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ecd3d6dae8b8649544e7aa2c71feb5c9b4ef44387bb3ac63d1ca0519a391b5c"
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
