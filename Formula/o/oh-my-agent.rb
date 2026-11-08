class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.37.1.tgz"
  sha256 "d1212c64d50ae676d5016f701299c85cf7daca1f23ced117d587baeaaaa416d8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5705ef8b1e4a759d9c5e247b870a9fab5939ff0d4d91ddfb8cc4175f459b86b9"
    sha256 cellar: :any, arm64_tahoe:       "48d7345739d424aefcef84221d36af9fe265b832884ea4ddd61e869e04de39a8"
    sha256 cellar: :any, arm64_sequoia:     "ab8a2be26688a754e7b39e9ed4d7637076f325a5b91b1b7bef56fecddea03560"
    sha256 cellar: :any, arm64_linux:       "179a6539a3c16cee516cacfaa7d3c4282f2e998537651a66269934cd948aad47"
    sha256 cellar: :any, x86_64_linux:      "72a4174f5f7566a1f754d18e6533a2c4db2f1eb656b343fa277848b452d56d4d"
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
