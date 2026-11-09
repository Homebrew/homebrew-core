class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.38.3.tgz"
  sha256 "fee72a84c974a6476694d0c7d44cae4aa71d06655044c4ae753ea186a092ba9c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "abf116a34c038cfa5fb542298ea941c3516918345348b91a00c7c041c6790de7"
    sha256 cellar: :any, arm64_tahoe:       "610fe7c73d4f6a07bfda96d0a05669df3366ad28d510a66a1d529de9294fc789"
    sha256 cellar: :any, arm64_sequoia:     "89fb82a9aed172ad11f31394618ceabf7993af11e3810937afebdcbe6bb0ad33"
    sha256 cellar: :any, arm64_linux:       "d374bbc78aae1c4648adba2f79a764119c07e1b583c5aafcd1ca939d73e682a2"
    sha256 cellar: :any, x86_64_linux:      "427044f977ee85ced29ccf46a395123446648c71f537eff9aa519c55d95494eb"
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
