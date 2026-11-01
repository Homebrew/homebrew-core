class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.28.0.tgz"
  sha256 "bfb16bfee7d0163ae94d9c42e914b224ddb201a3e618b70d20bbd74a61dee76b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3f838e93ae849ea49003f369415aeb5a515175de8b87b2be8672261e5f9efa32"
    sha256 cellar: :any, arm64_tahoe:       "55d09f25777dacb1946bd61874402b328975922deb3e9a78b421b12958214b76"
    sha256 cellar: :any, arm64_sequoia:     "863a1ac3d6c5e4e453dbf3037c55d619ba57f9852ae5bf7212acbbf4f9d12f37"
    sha256 cellar: :any, arm64_linux:       "c1ca9cd7c6849417d66826f5c399a98f91279eb3fc16e98dd9315204f324cf92"
    sha256 cellar: :any, x86_64_linux:      "7082deef1fb3b649b80ff6a18471fac2892eddd82981d74ab703ee98ac857a20"
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
