class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.40.1.tgz"
  sha256 "4042cd54613cd5bc482eb19a3c00123a8e9f52152d99405d7161d8c058d39bb8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "18d4783a402476f3933cc065e52a25fc8aa6e8c8b5ad793c23cc54e67a50f1d4"
    sha256 cellar: :any, arm64_tahoe:       "d5cdf9913cecdd0a248ca52fabb7129f87538eb19b6cde005b0b8485b47a6631"
    sha256 cellar: :any, arm64_sequoia:     "44a6791462ec6fc9c9fda05f78fbb20e031a6bf42bf529fa6e47a451c85a6d94"
    sha256 cellar: :any, arm64_linux:       "7452806f22662798daf430d0ab79ed4b86192846c204c47b1bf765523e999ac6"
    sha256 cellar: :any, x86_64_linux:      "606063b466e3f5d24c1b4ebf6a704e2c79fbf2f35b2314119685e230b0bdf2d6"
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
