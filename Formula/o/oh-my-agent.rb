class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-21.2.0.tgz"
  sha256 "e1bdc10452fb32ba676e58885f9bb2235724d356fd077e475eec94edf6002f4e"
  license "MIT"

  bottle do
    manifest_sha256 "8c2e4c58c4d61e5f0314e41a1d7069079cb5bf65280accb478df05086b315f50"
    sha256 cellar: :any, arm64_golden_gate: "879f7c61effeb3446d692d9190a6ceb1049d840aa9171374a0885cb524aa9825"
    sha256 cellar: :any, arm64_tahoe:       "e9aef5479102e4699c622fad8ba56686ea8384e4fba594c7e2b79d9d08597c0f"
    sha256 cellar: :any, arm64_sequoia:     "e043e864ed12ef137a3b859c069b2fcf75beb0c0f92952b0b1e1bc0360138f17"
    sha256 cellar: :any, arm64_linux:       "2298281b83c4660dd479fc658150ca23b8e64163137f366dee1cf959af2c3408"
    sha256 cellar: :any, x86_64_linux:      "599d92e576331b40534d2dd57ab942658e25a236de3e98001a8536e57138e163"
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
