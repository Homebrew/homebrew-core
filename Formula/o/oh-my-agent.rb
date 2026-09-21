class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.14.0.tgz"
  sha256 "b8b578d757aafba09541f508a11025894c52800285a249270e882d75b69c3653"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "24cbba2d9d95ebc574e58a7afce431df986844a111c77b7d0a7e3d70cc5b1351"
    sha256 cellar: :any, arm64_tahoe:       "7b77d1d0cc067554ce815b2bf1abd4049db17607f4c5424b354cd2422ad94b1a"
    sha256 cellar: :any, arm64_sequoia:     "27f79d9f95599dde1886c2983e0f4a036e08ec47f1fdbe38dad53bbdff57716e"
    sha256 cellar: :any, arm64_linux:       "cf94c3c0de1b3af0bf4dd98a7a1e31111168c389d2fc90e9d2477604d93fab75"
    sha256 cellar: :any, x86_64_linux:      "7c233f593d13b217b7e9968b8f544b63fc0b78add2b00e729e9252f9a7a0bd96"
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
