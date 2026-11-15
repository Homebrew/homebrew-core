class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.43.4.tgz"
  sha256 "e2f2c6c1fd7baa7f1e92290125c108092782f0d3c1248706ce0c36db40801413"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "884d2b71d86fe2472bc4fef70586c66667300aa1e0f4f8227148c0cc65a97888"
    sha256 cellar: :any, arm64_tahoe:       "b6917192db7f1b6f0f18433cdaac38ccbcd61b74855335c15f155b32ba701a7f"
    sha256 cellar: :any, arm64_sequoia:     "8587a4cc136fe19124180ac43c26d80c10b3466c346f01d5c578a2708ea1cea6"
    sha256 cellar: :any, arm64_linux:       "a08d29ff1d33a067841bab2c253413ff06ae0b3c108d4908d8ab056e21e2051a"
    sha256 cellar: :any, x86_64_linux:      "c6beae05c0937675758895607c0b43132a51daf419eaa4966b91ce6e70e824d1"
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
