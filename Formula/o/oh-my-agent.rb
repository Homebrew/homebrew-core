class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.34.0.tgz"
  sha256 "4ffc4f798dbfbe6182c12d5e9ca4175bea42547b92ba74a313e4b935f35246ab"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ad43c71b2e322adcb6746bca055dfc781bab03b4c89198459b78e406000d1cdd"
    sha256 cellar: :any, arm64_tahoe:       "e37b9d561aa197abfd3dbd9efb62ca4ab584a50dd99bf6c1eed940d81b52980f"
    sha256 cellar: :any, arm64_sequoia:     "590682e0c2fa8163ee383c579d197f359f13f2715e655309cfc68b547e545444"
    sha256 cellar: :any, arm64_linux:       "1a77a925ec7da5cc314df3fe8315e0dcb22262f07be965516c045851e1526ad9"
    sha256 cellar: :any, x86_64_linux:      "6f634dbfc22efc15d4e9871608cc445408e28456af11572dd4553d5405f21a32"
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
