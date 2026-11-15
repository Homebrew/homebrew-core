class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.43.4.tgz"
  sha256 "e2f2c6c1fd7baa7f1e92290125c108092782f0d3c1248706ce0c36db40801413"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "91385b4cfedb151626cbc3b67169d69084b3758ade66d005d6833b94adc1ded0"
    sha256 cellar: :any, arm64_tahoe:       "6187b1cac6b2d04994b1b96083f25475fe8b582e89ab69340c4d93faa90e13eb"
    sha256 cellar: :any, arm64_sequoia:     "39d4e88290c06da19512bf924fed911198775c70209f0fca7b1ac9b05b93d8c3"
    sha256 cellar: :any, arm64_linux:       "1a6649e1ed6e20aa33556ac36a68463e47e49ad62f92fcc28fca6f77b8aee98b"
    sha256 cellar: :any, x86_64_linux:      "9ac66779a2d1e440efc37ada864d06aaf77a68b36a5e20ef62b13bd3a210658f"
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
