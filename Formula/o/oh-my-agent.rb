class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.40.2.tgz"
  sha256 "e736cf7efcbb3d81100c9dfeeb076fc99dab86b72c510168a229ab510835a56a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1ea331a604dd8700030001942c35847c84074b7a2b3eefcc9910f149bfd73405"
    sha256 cellar: :any, arm64_tahoe:       "e51060564a6a6fd0c5a4263f049518e99fd6b1112b7693060dc89a3bcecfd50d"
    sha256 cellar: :any, arm64_sequoia:     "359908e943b0bc5a9277569240d196826d57336ba54250a55774df9be4f2ef3f"
    sha256 cellar: :any, arm64_linux:       "fbd9216ad10cdf267dddb9bd15258afc04c17bb56c24a42cd29b556748973503"
    sha256 cellar: :any, x86_64_linux:      "3fbe41cfc52ef712e2c82df5474fed77fc5955e6b680ee265fa286dd27ef755a"
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
