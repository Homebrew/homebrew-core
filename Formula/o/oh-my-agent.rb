class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-21.0.1.tgz"
  sha256 "b330bb8ef868581e32617af12387fa7d77cdb4ef431fe6063d455439cca2a4bf"
  license "MIT"

  bottle do
    manifest_sha256 "06ea765c502b50e2533b7ba6af24d27381a62271522d7a9accb92d85e7bf85ad"
    sha256 cellar: :any, arm64_golden_gate: "4fca19a1a3f337d9aaa358f7aa5243494dd428ad3e226a6e54aa56ba63538212"
    sha256 cellar: :any, arm64_tahoe:       "8493e1e142084e10b4ce579b832ffbad3c42956cbcf47adf2a129b904559948f"
    sha256 cellar: :any, arm64_sequoia:     "0d0963fce557cfe79cecfb4122254233811e90b5162aecb2f8d53c57c7f8b92e"
    sha256 cellar: :any, arm64_linux:       "40494b301f579ae1520d17a6960a119df3ee5e3053a10c9fced309cd6e29d0a6"
    sha256 cellar: :any, x86_64_linux:      "2e7a15d71461a391dc07a5e233d461834c8157763e16dfe93d73e3928ddd5df0"
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
