class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.24.0.tgz"
  sha256 "8d7da8e854fb4b2001d2812d24a82bfb2f5459cb60f0555a889b2d073df5a601"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9d72d001fb1dff99a9b90810523c9a9b25de1d2634e8ac624b4be6f864578c63"
    sha256 cellar: :any, arm64_sequoia: "9d72d001fb1dff99a9b90810523c9a9b25de1d2634e8ac624b4be6f864578c63"
    sha256 cellar: :any, arm64_sonoma:  "9d72d001fb1dff99a9b90810523c9a9b25de1d2634e8ac624b4be6f864578c63"
    sha256 cellar: :any, sonoma:        "7f0533af21d2bd5b332d364794d5436b7c413b6e2cccbad3b1e02d7e4f94888a"
    sha256 cellar: :any, arm64_linux:   "fae58184c0b2b33b86292486f61fd25b22c7213dc521b882696e5739e76625fa"
    sha256 cellar: :any, x86_64_linux:  "34a4776fbc66e09c508668f3ff11f39573c9edb5e4183ac7b897abdbcb048122"
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
