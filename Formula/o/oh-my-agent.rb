class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.7.0.tgz"
  sha256 "7197a6b1d98c9f4d98c3b9c6f0c329d96e85d612cc1e35a8d8232735723098a0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "477b55e20d9da2e552b7f1ea690e8b2cd12cdc1f1356d888ab69aa160395349b"
    sha256 cellar: :any, arm64_sequoia: "68425988691e6901acf18eb6910241a3d323b7dabb6930132f4a15e7cd86e446"
    sha256 cellar: :any, arm64_sonoma:  "e4394fbc3c696f592a041c7eb0845a6c610d18622d56c7d065802ca6cabb558e"
    sha256 cellar: :any, sonoma:        "044dee6ae265611415c4e91ccd92005fe404c24ac4a3335bc85aee8d7ff2ec29"
    sha256 cellar: :any, arm64_linux:   "802ae9df9fa5f928d7e5ee1a5583f9beaeed2afbf162eb1feeba8eeda72e255e"
    sha256 cellar: :any, x86_64_linux:  "1bb57d6d65af69320ea76c70fa22808bff5844541bf7137edbd3313b0cd74c08"
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
