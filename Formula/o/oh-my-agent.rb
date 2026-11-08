class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.36.8.tgz"
  sha256 "6fbc6dd7051687f91a1809b3b19d6653aa0b18f622adb24a29b2a5c7b9608751"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "458a4ec47e00758974360373cbccc7bb253b2def9e4428ed177f8d7384fdc143"
    sha256 cellar: :any, arm64_tahoe:       "0ccc0d652076c8d5e902078154f2ebbd2b9670f7a74dd06c414017ebdcb24b92"
    sha256 cellar: :any, arm64_sequoia:     "0eb19a21852280c185dcf1f4d48472228ce13b0f40a8b9b6e80c7312909af95e"
    sha256 cellar: :any, arm64_linux:       "e67ed9ef57f2e4edd5efa480c3c8f0bf2506fa425e6843974e4dc7e564bcb82d"
    sha256 cellar: :any, x86_64_linux:      "b4f05e51638eb1c71e12e1b69d279cca7fa2afc4943d7a98f3ca0ae5978571c9"
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
