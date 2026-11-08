class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.36.8.tgz"
  sha256 "6fbc6dd7051687f91a1809b3b19d6653aa0b18f622adb24a29b2a5c7b9608751"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dc43b295a28046c742ff329894ce911c20c8adee219a1f52eb97af6de7caa15f"
    sha256 cellar: :any, arm64_tahoe:       "988b9dd3af7a3e30a0f543f5c95f83d57c49e812af12598e4495b1f513f2cef7"
    sha256 cellar: :any, arm64_sequoia:     "d9182b364ec8c221f3cff068f2e8102ea887cc2b1b989db15f21dea2f092f6a9"
    sha256 cellar: :any, arm64_linux:       "c7fda928bf98ebda23a9d13c353af11312fac205d5301e60ccb68bd273632103"
    sha256 cellar: :any, x86_64_linux:      "eca3d32f1fb416c2176142e53c48fcae46fb5a6c37ff0dd7890b8d38ba20f8ad"
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
