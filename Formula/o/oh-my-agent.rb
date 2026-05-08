class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.15.0.tgz"
  sha256 "d963a5e30a8959da844d05f53583ecdad6f198dfdebc2c4bdc7d2e49fe706186"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cdf3ccab5371eba908011bd8f482fca40ef6b7e215f98ce7b50a2cefc4e61280"
    sha256 cellar: :any,                 arm64_sequoia: "b02f1ee00194df07d609bf671be6a399fcd9b64ac1283a7ed448762d275dab24"
    sha256 cellar: :any,                 arm64_sonoma:  "b02f1ee00194df07d609bf671be6a399fcd9b64ac1283a7ed448762d275dab24"
    sha256 cellar: :any,                 sonoma:        "d6e537030ff0ea4e0af1649271a8595ead6c38e40e02a2b8caba4e5424ee7018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ec62a40517eff12e30b8013788cf0ec063cc54f168c1fc2537a6c70ba8c84bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96136481ace96ecaf27059ed10fe7562f09906bb96b5e6757d0aad24d2694fa0"
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
