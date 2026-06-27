class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.4.2.tgz"
  sha256 "beca2c46ac127ca36892cdfbaab67ec8295c1b476c244f3d1ac0c76aee10e39e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "133b199888e39a0c52105c4fbc71d783548b131cc2fe84de961f05ceafe386f6"
    sha256 cellar: :any, arm64_sequoia: "692b3ca0179b83b2da4f82349ea6fa1b86bb3aac21b649637da8fbda3c91a175"
    sha256 cellar: :any, arm64_sonoma:  "692b3ca0179b83b2da4f82349ea6fa1b86bb3aac21b649637da8fbda3c91a175"
    sha256 cellar: :any, sonoma:        "e04ebfcbb893102c5e2334509a4d19c427dc6440b43f33ba567f6f4f92005bd1"
    sha256 cellar: :any, arm64_linux:   "4f7b0a00603b6cb0783e28fa444ce0f55f2557218bdac9eb4b0733d1089cbf8e"
    sha256 cellar: :any, x86_64_linux:  "8efa485adc93fa9d9e627bcd5d28ed09659cd8ae7bef4c533abbca0a0f026b64"
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
