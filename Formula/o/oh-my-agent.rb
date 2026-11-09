class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.38.4.tgz"
  sha256 "4b0924cea650300bb48dbb4e6f12909e2836f28b45d32d208c57ec8a7efdddac"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b34cc2e64114fd0e60a1d23b7e72dac1aba67e6fd27fcc4e709e9937c28f8514"
    sha256 cellar: :any, arm64_tahoe:       "17592a8c221e22da11d7cd3141fc210a20eac1235d1fede5afcfa7dabc59a66f"
    sha256 cellar: :any, arm64_sequoia:     "a062884634602d35a94afb0c1817d6c9e01af72fce96e21295e488cc882a8114"
    sha256 cellar: :any, arm64_linux:       "13d8198eb8694f200c595bb55d712c933673c6aa2390f652128c0ac93e4fb6ff"
    sha256 cellar: :any, x86_64_linux:      "813807c7fb25e08f3e2583c3cc9c5e669b8d7621496a159bd93b4a5b84bd785f"
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
