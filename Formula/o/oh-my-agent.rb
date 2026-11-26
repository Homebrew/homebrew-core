class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-21.1.0.tgz"
  sha256 "6761e37e95f34f97ed735a237e68e3604afd4bdf320ffaeda0663ebf0b5e94ec"
  license "MIT"

  bottle do
    manifest_sha256 "5f6da8002064d217adee440178fc4b222e4759bd7332a6325fec27e6c79f00bb"
    sha256 cellar: :any, arm64_golden_gate: "17a7268b0a016a542b4001ec3981e44a5f47ce8df76302c215a1ade312d9dc82"
    sha256 cellar: :any, arm64_tahoe:       "e74093df1d07d3b296f1f8125a897c4abd959acc6fc9b54da72364b3ee4e339a"
    sha256 cellar: :any, arm64_sequoia:     "f95533f7724386398d8ccb0725c3dec5fad91f3c9aac9ec74987ac2c501a32e1"
    sha256 cellar: :any, arm64_linux:       "7cf5d2c116f9a7cf17f568f5771b64014c905e6a186c107e351b6f8ada9d859d"
    sha256 cellar: :any, x86_64_linux:      "cca81d6035c54da9f9188b1b569eacade5ca5968b3e8334b69b0c1a36822a9f4"
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
