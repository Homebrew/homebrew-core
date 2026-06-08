class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.42.0.tgz"
  sha256 "ceeedd3ab6a8c3061df8121cd541fe4e6d9691a9fa00e6beaee8a6cabc19e3d4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6240c5341cb0c13be5e533feffdac79795e004d8417d14dfbc88f9073dfb03a2"
    sha256 cellar: :any, arm64_sequoia: "3628e419e3502ad124934988129f8224297e76638db20e6fb4897d44e75aa3d8"
    sha256 cellar: :any, arm64_sonoma:  "3628e419e3502ad124934988129f8224297e76638db20e6fb4897d44e75aa3d8"
    sha256 cellar: :any, sonoma:        "2c9073d47b3adfdc334474333410c1216cc2df9351a83620a76471f1b440a880"
    sha256 cellar: :any, arm64_linux:   "766c06c29ebff88c53381020af876963adc6de34a74b3a638eebf7f0d2103b25"
    sha256 cellar: :any, x86_64_linux:  "f0eb82a06b82a8085f63f8719cbbebc5a44c59e081341129f947e16a49a00ee6"
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
