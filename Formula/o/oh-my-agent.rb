class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.2.1.tgz"
  sha256 "79b58f169cd83369fe45f17785c4c23601f135da93a7408c8bf9c4ab6aefaf8b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "10706f1aa5df3c6013f355a0334275527c40913570e01fda2d9d8d2914036d9a"
    sha256 cellar: :any, arm64_tahoe:       "1ea6cfa2f0d68c97b50c1e5473261f8ee0e2a3e2a048614bc7d9345e7c9da08b"
    sha256 cellar: :any, arm64_sequoia:     "0e3c95974dee98d8e3df70c263bfa4c2e46e2cf0d6a15e2c07ecd02d988977cd"
    sha256 cellar: :any, arm64_linux:       "44f5d9335038535e9a8a2f110d5ad4021438d3b8de05265f66949c59f131bf91"
    sha256 cellar: :any, x86_64_linux:      "03c0fe4d6880a340d3be58d40a1c10a7da38361651c470bbbee587a291dc12bc"
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
