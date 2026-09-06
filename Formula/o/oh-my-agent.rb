class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-13.3.1.tgz"
  sha256 "99661791fac09fed5afa4d49cd3e8c5cc5350fb62e379e672ff9092ca3481415"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "183b4bc5540748d1445691f775a209b3f791f8549903e6ad23178780ebaab17d"
    sha256 cellar: :any, arm64_sequoia: "8fa089e3c04d0d1a935b14baf6e4fc35bc715efbbdfb39e9b1bf60b4032c3704"
    sha256 cellar: :any, arm64_sonoma:  "ed9ddd435c90ba4028610a90d76077143374bb9a2c9fd19ef069dae3b38af499"
    sha256 cellar: :any, arm64_linux:   "81974e2bd7d9663acd7e6b0fa2075a4d98d73960efa78b955c72d2ab7ea54e2b"
    sha256 cellar: :any, x86_64_linux:  "3eabf1f060671adc5bbb561fa7d4f3fd85b83e1a7ad85d845e641b254c3a35ea"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
