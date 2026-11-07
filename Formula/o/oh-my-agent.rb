class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.36.5.tgz"
  sha256 "d60f11615a88661dcd274df1c472b7a3a50276ad3453edd75adf4a9209189d41"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8bf733f18374b6446b54ff830e5680dc38d8ff4b399e7d0de6299fd837ed9d98"
    sha256 cellar: :any, arm64_tahoe:       "5eaa25d83ee7db778065e631dece6f10fa7660c248cb1d6bfb7920ea580d8c0e"
    sha256 cellar: :any, arm64_sequoia:     "c2ee496482eba383bfe3b50d5af214799c0e71ce4938162926a38a4a4f1f60b4"
    sha256 cellar: :any, arm64_linux:       "2f979e3732d9fa94331b1603a597def92d5d924bfa7a4c3cfd43ee968ecb1b8f"
    sha256 cellar: :any, x86_64_linux:      "57a8ebf173845e385d028c0502a5d54b6f27581e72d6566ca499f66495d727ed"
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
