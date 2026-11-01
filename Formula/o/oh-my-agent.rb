class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.27.0.tgz"
  sha256 "33b795c16750aae442c3c19671dcccab95ffeb03d11a30809b00635f1eb73413"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af1033c636da61fbc2ad217b1440a07d06543849d3c260e9001d223178f48afe"
    sha256 cellar: :any, arm64_tahoe:       "29983bb4bc1e4b9f8920ce0aa80b1285bdacf4dd88d415fb80122a4cf8207f88"
    sha256 cellar: :any, arm64_sequoia:     "e7afc51d75b7d99c4f5b5c6a16d7511213860f939eda293e857a5459963c5980"
    sha256 cellar: :any, arm64_linux:       "01cfc5531d3f512deb696afa0cf97f3d966629e1126e50cf74ea5fe9d0872f87"
    sha256 cellar: :any, x86_64_linux:      "4caa1f9daed1a4427f91f403beef86f449c2c0a44b426c7648be2f3628ea08ac"
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
