class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.3.0.tgz"
  sha256 "5ef1e3807e1d9fef24a3245f6020ba50c1ea2e23f767db0f1ad82a1b447088c5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7af3942cfb025cd8e8f9bf26e3ac51445531dc6e8c455fd029c2a8e01e20cde1"
    sha256 cellar: :any,                 arm64_sequoia: "088afb29bdc69d597dcd282b84a7c6d000974cf5b6288a52fdcb6efafe801cbb"
    sha256 cellar: :any,                 arm64_sonoma:  "088afb29bdc69d597dcd282b84a7c6d000974cf5b6288a52fdcb6efafe801cbb"
    sha256 cellar: :any,                 sonoma:        "185cabc06a7eda43eeb1a851d2dd6a1c3a053e03db163b5f8b03b50c6126d280"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b2eb7ac280b54ade7f54edd215ff6380b6f9ad79b216fb62c3cd09f64a13d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a599198bba4b9b6cd4ae1f09cdb71175179540cada5403ecd4b008e8ee924d"
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
