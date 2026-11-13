class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.42.2.tgz"
  sha256 "5c8e0b47ebcc897df6a27d3c6591b75b25502b91036db3823e6c4d63fd08fdf9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "24b22da3772ccb792ceb5f2a6dab70cd88c4b5c995f966cce0afe550226aa91c"
    sha256 cellar: :any, arm64_tahoe:       "929a54a8a277fa369e5385d30a0456a4f0c4780f45a515a7600bd423a782760d"
    sha256 cellar: :any, arm64_sequoia:     "b528b0d17e55ddc90cedc4b50737d71314c9279f9830d5f3133feafbda80815d"
    sha256 cellar: :any, arm64_linux:       "5dd8f7aa19ce5b792a0027410ed3bc1bca065a5b42fed256ef835d5bf5ae4d9a"
    sha256 cellar: :any, x86_64_linux:      "2bc05985eca5fa158c1d14012e05fb95af1e48c5267788c1bfcc1efb18e3a08c"
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
