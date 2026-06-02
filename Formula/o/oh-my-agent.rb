class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.25.0.tgz"
  sha256 "b2444de74d7cadd284bf568e7eb1a647ea76473bf66418aff18a9064ab1a18ee"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "815e816d247a25022314134233897a1c3f2174ba23af155bd714e3312da591ff"
    sha256 cellar: :any, arm64_sequoia: "68582ddadf9ea79cc8438ae87f1f3ff1d376b46e4968a208b57a664374060b3d"
    sha256 cellar: :any, arm64_sonoma:  "68582ddadf9ea79cc8438ae87f1f3ff1d376b46e4968a208b57a664374060b3d"
    sha256 cellar: :any, sonoma:        "4c23bf033f22c5a374417ffa0ea8e731e7d4daf9255022af2e197bfb23484a6c"
    sha256 cellar: :any, arm64_linux:   "dd504954ed52640ef23bc3faeec315003dde3773c00bebab5068387fbf657858"
    sha256 cellar: :any, x86_64_linux:  "a1b138ab388d75db167ee8c9a067267a8098f0ba15bdc50da5dfc1add697a5de"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
