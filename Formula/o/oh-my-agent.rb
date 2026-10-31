class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.27.0.tgz"
  sha256 "33b795c16750aae442c3c19671dcccab95ffeb03d11a30809b00635f1eb73413"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d1626f6323ecf6ab8a279d074542dfea8a1942889fc577c8ea85e3cfa5d30352"
    sha256 cellar: :any, arm64_tahoe:       "4fc18f511e2031598ffbdcbeaa49ad940f1085df10c2ff1a3776a52982ad58d5"
    sha256 cellar: :any, arm64_sequoia:     "0b26043880e36b515a76afdb9acca1c76d68f44189a3c4f993d6957b438e77d3"
    sha256 cellar: :any, arm64_linux:       "028fe13aeaa5bd1fafdc02578cca0a484e9ca2d10742543609edf48f91d61b84"
    sha256 cellar: :any, x86_64_linux:      "c805f4729a6d92af1dec2c8142a58392fd21a9925f0217cbeceba8550b6a9bc2"
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
