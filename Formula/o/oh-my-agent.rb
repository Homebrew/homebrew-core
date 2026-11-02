class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.29.0.tgz"
  sha256 "27ab48b8329127f2f6e40e51b58b9c3fd5343126770376e0b16f6b395a12fb63"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "17599979601464578e4ce73d4e28a3479d0446003a97ab371b5626b544923823"
    sha256 cellar: :any, arm64_tahoe:       "6e6028d84f10a82d9eb447d858b5e8a36790d737882e0aa360a3fe033902080f"
    sha256 cellar: :any, arm64_sequoia:     "892bb104a605f1e86fe95d9ccd6364f4bc8a2121a9a05ff14bb729b9ef0ca8bc"
    sha256 cellar: :any, arm64_linux:       "51e258c68576157dac7d68b4da96d87807d8bcd68ffe22dd8f8042986ba49305"
    sha256 cellar: :any, x86_64_linux:      "8c768aabf0829d8b426a34ae1da2a41d34173654854e22cc511521dcbb06e118"
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
