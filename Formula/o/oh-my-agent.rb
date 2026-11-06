class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.35.0.tgz"
  sha256 "c0037f921400f0f9d626dc39120cf63a56c6e950f87b597a055d3494e600e79d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e3d274fcfccc93bdad00e90add30260b82b62b6c3d0a562d83205b7adedfcf3c"
    sha256 cellar: :any, arm64_tahoe:       "6605e7fe53a6fc3e44adcd25c12692bf6ddb34ef5f8d7271e359ddb06686f6ba"
    sha256 cellar: :any, arm64_sequoia:     "95f8ec23b794924c54a8e951ef50feeb994e87aad582926ba39959351e715fea"
    sha256 cellar: :any, arm64_linux:       "81ae52cf36c3ff5f2e5a1ab286c119917bc7268657f78a6ef99b3dc63fd71ff4"
    sha256 cellar: :any, x86_64_linux:      "5f7b0a26c37be740402f6e65ff2ae7eec8a0f664ad50185e605e2806234559d7"
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
