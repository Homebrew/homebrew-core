class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.40.4.tgz"
  sha256 "5a7d0509ca1b866a4977526b4a7eb4b548dafcaf15e9343df13e05084220f4d0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ef8482ca4dad82ca04d10649dc7b84e944310e4bf17e0f7dbb8a7d1dd00b3b0c"
    sha256 cellar: :any, arm64_tahoe:       "2e655471665b4b8af847e5bccbb42654b0487691e7c54a6d665c8ced8e9ef6dd"
    sha256 cellar: :any, arm64_sequoia:     "b806d66551526223395480b63e41ffb53eae9127074ce062fd02886bf02cc70a"
    sha256 cellar: :any, arm64_linux:       "86c6350824f7b155b842fbd27e7eae54edc74c30877f3a92d60bd11ca260d566"
    sha256 cellar: :any, x86_64_linux:      "b1d9dd84495e90f6b6bd04ad62606b54d9d81a5f8a59a60be417a65daba313d4"
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
