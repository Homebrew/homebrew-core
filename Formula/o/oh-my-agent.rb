class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.36.0.tgz"
  sha256 "58a7e2333e586cefe83c6778c9162f9e420fb9e77486f1cdac749150179c5773"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "739ca1a15351a99241182262362a983a6dcd87d579f192512929317d9c1101b5"
    sha256 cellar: :any, arm64_tahoe:       "45d19b1098246148613d650066bd61283de27251ee1c822b19faa60d9121c898"
    sha256 cellar: :any, arm64_sequoia:     "8b69e30b12d76859a9175a206c1a311e8f50c4c4b9606b4ae4aaa9a8f820fafc"
    sha256 cellar: :any, arm64_linux:       "483cedb86f10d37f15c3bab61806d59e9fbfbbfb5a3bf173ea067d4de24526f4"
    sha256 cellar: :any, x86_64_linux:      "f3ee17c7894f5ad70401945e03c5f1bae4411b06b33d159c15453a009a91cffb"
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
