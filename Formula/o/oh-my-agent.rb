class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.8.0.tgz"
  sha256 "5bb591fb71681163e56506258096979c261e8f6c40601ff4d243de59557dacf4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c02e89467272691eb67cb54038b69edc7aa651c6c744900d270ecae29e6abc82"
    sha256 cellar: :any, arm64_tahoe:       "95eaf5d8e0496dd2d1358076169b470458a6bea321a065f550aac6060ea57870"
    sha256 cellar: :any, arm64_sequoia:     "90d3f70801229de0408f892578b6c22d07b0cf85a6e9d47a35f3d01d1bf1a5eb"
    sha256 cellar: :any, arm64_linux:       "efee81b48967bbfcf794116c608629361e4a9dc15da6b4d93b63905c8f38182b"
    sha256 cellar: :any, x86_64_linux:      "6a1977a8a9f80fbc52b58ee1dde0e557775b6d87e35fe8c5c564fcdbc26cf4ef"
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
