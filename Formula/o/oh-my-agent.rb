class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.45.1.tgz"
  sha256 "9da0d69dcca31c8aeac5ddbbdd47b28a6a1a8b85a6e241d92aa7bd45027c5408"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "047661a276e0173b77ee5d2f19c385f9222855af05efa1f40754f528c38b6dc5"
    sha256 cellar: :any, arm64_tahoe:       "e68dfe1030ff882500ef38d785813e758f931abac8396478ece28c8a2b44a33d"
    sha256 cellar: :any, arm64_sequoia:     "ad0870c6a8bada18a56e038c2782c2d924529fe461c9a73f93a1e743c0cc4754"
    sha256 cellar: :any, arm64_linux:       "187334630ff689003eeac97d483b4e8534907ab13317091e53651e546b35ab78"
    sha256 cellar: :any, x86_64_linux:      "cf7c8673273b27c547c030a035b244b1f9d282a392b90b34832a458d1b65db43"
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
