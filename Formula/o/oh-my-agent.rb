class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.32.0.tgz"
  sha256 "9737d8850bc63887c836111def399139bafeb54ae3c1762a07eda97f12a9c17a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "db9f97391bab28f3ccf174a11b96f255b83925f8060f95375ff34fa922602e41"
    sha256 cellar: :any, arm64_tahoe:       "5346485ed8536a8a3729ec963354bd39fbd5ae5a823ed19ec13191588a0a5829"
    sha256 cellar: :any, arm64_sequoia:     "108b6832c3fb61677c983b77ce2967b5347980325d5a8d11a43ed4c91c8f36b2"
    sha256 cellar: :any, arm64_linux:       "ed8625f73646818834d57c5b814f0b5e5a9943c5a6c95d69667760530f4bcceb"
    sha256 cellar: :any, x86_64_linux:      "4a67967570f28fd56ef825508b3ffafa5998d999413635c660740f02dc20b6d7"
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
