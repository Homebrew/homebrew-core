class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.34.1.tgz"
  sha256 "e89ef69ece61c67ff4b0eeb0578afab7c65d43691e775cf408132eb33a2d2b61"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e8177ae7067770f2482cc1e9b70868a7830efc9e7b15ca6172c8064828e3cf91"
    sha256 cellar: :any, arm64_tahoe:       "53881f7c19aa1d4034f293b872e15f9534eda29cc3ac944c9ad439d95bb77853"
    sha256 cellar: :any, arm64_sequoia:     "3dfeaa0e6fc897e3f56c664cb93df3122a32640227ad7aa77fdb454495d90aa9"
    sha256 cellar: :any, arm64_linux:       "09ea813bb01dc85131feab662d04e2459c99edbfacbb7f9326b5d2b1b4c1bb01"
    sha256 cellar: :any, x86_64_linux:      "12a4f6130f797a762dd686c6387bf0d7fd2b96fda80844ebee81ef1389cabd53"
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
