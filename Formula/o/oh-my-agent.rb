class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.43.0.tgz"
  sha256 "b11aa71abd35d972c13780e1042a84bd0710f057f94f9602d142e642bf0add50"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f679024cd67ccea8d54db4ba60ce895b6155bda4435b1edf6072e590e18e30f1"
    sha256 cellar: :any, arm64_tahoe:       "1707cb98b1e6a5522213b6f73c7aa0b6702d987dc34f33243490acc3b9dc4ac6"
    sha256 cellar: :any, arm64_sequoia:     "cc15521d435727b213a6cad5fed5c984744fbcfc1abbc9d504337c7866abc841"
    sha256 cellar: :any, arm64_linux:       "5b9dd644ef45902dd03b70402d6d1c5474c4b2ffce06f84b935dd5b861822a87"
    sha256 cellar: :any, x86_64_linux:      "5d19052e5495495558174c508d82cc33efdba41f52f2b7a9a91a2f591e1fbe01"
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
