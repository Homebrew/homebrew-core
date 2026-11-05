class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.34.2.tgz"
  sha256 "83fba3cd51a18871a6a3f830682a9966b53fdd74d5352c2576c6493730456eeb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b3e18df9fec94eb6b8788a18fb1fb99f4b96eaecbba664e3a188ff1099b23886"
    sha256 cellar: :any, arm64_tahoe:       "a92d265fdcb2ee04cc9dbe317c7fcf077d6d220ce5c2c9638316fb63250a622b"
    sha256 cellar: :any, arm64_sequoia:     "0595da8ae44c064ead87214980fac97ca71caefd48ece7e73ab8ebe99015667f"
    sha256 cellar: :any, arm64_linux:       "0ca9bd71fbfe2d0b6eb44dbe0fb9221626b7b0213092651be25aaff958a7d013"
    sha256 cellar: :any, x86_64_linux:      "f10e4f39bdccb05a603c57eeb5f5f04f8961d315c4f96a932cf5b4821f912668"
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
