class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-13.2.0.tgz"
  sha256 "13318c4957bd17ff3d75a849f7403a47a7904454f85caaccabbe0ef2f218ac44"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b06fcdcd7be2cc0ff648a37466c3d58a0701f35c395098327fa0cfb9ef0ad34e"
    sha256 cellar: :any, arm64_sequoia: "e420f2082eea326d816532a485ee8925463645a7e30e3afa0453b2adc80f4106"
    sha256 cellar: :any, arm64_sonoma:  "04127f18e3c68534b7a35dfe07f8a239a9f859cd40e03647ecdcc9e926026706"
    sha256 cellar: :any, arm64_linux:   "7d4aea616b9a2dbba2625a37c20521f041fefa1bc90551f951cab2f310f2081a"
    sha256 cellar: :any, x86_64_linux:  "5741640c052b44d82827a5ac931fd7d214a5a30f6e3965a3eb7dc0397e883412"
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
