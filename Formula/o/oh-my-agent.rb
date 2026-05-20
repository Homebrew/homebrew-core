class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.22.0.tgz"
  sha256 "0e5f71291b73893fadeb0cdff325ca0c25a32c68aa88e7ddadce62784e9d4ed9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bb0109d21681d910b3bf639d10f732dc8794290e5e22d617c34bc75d0ac7907"
    sha256 cellar: :any,                 arm64_sequoia: "0e6fa2fc7901ce3d14c59dcc0d8ec046a84e527afda61edd8b19148aa74eacce"
    sha256 cellar: :any,                 arm64_sonoma:  "0e6fa2fc7901ce3d14c59dcc0d8ec046a84e527afda61edd8b19148aa74eacce"
    sha256 cellar: :any,                 sonoma:        "63250a51de6842d5023e50d69ec5188e09eca3f8cd9f96511afb029acf10cdf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe55452aa11c009579df0601e09a7fa27e65f4efabfb66fdf6809e5aa449dc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d1d97b9e51c7acd44217638daac2fb9351afbdd7bc518225efd817e62b1e53"
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
