class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.42.3.tgz"
  sha256 "7330780d424c90960f2535f64c6001b05ff835794371f1cb1fb36f3ba53ce022"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "38aac1923f1046cc372d347dc4b5a43bec3e0acdadb8b13da9bd854e48870466"
    sha256 cellar: :any, arm64_tahoe:       "a5807e4add4d6883011a6f6d43e071c0d94032667ae392757ef4e36013c04c6c"
    sha256 cellar: :any, arm64_sequoia:     "06afd98e306797e6dfd8cee5fd4d0a6c386487db385259afcdefad7571d3d906"
    sha256 cellar: :any, arm64_linux:       "44b16dc1db62ff3d875df1389dd31f4483c4877450f48b7854a948b6ee66c14d"
    sha256 cellar: :any, x86_64_linux:      "16620f03a3d5fcfbb91b02a9646e0fd8f1be8b8d630570d58935fcada0492d0a"
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
