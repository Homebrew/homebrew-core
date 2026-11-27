class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-22.0.0.tgz"
  sha256 "c2d4c27f498c806fbc0f308ae8f50c93fcf1e249a0c415c0ee159700a8f368f5"
  license "MIT"

  bottle do
    manifest_sha256 "d1a2000bac4fc00aab4ee090b89ef3ecf91f3023e49e16ef0e34eeea6c0e33bb"
    sha256 cellar: :any, arm64_golden_gate: "dd8822dc56d9c81d727f8ae3c87f1f58d04492933a6cb41474ef29445dd73c5c"
    sha256 cellar: :any, arm64_tahoe:       "98567d96787e5fa504cfe02cb17f8f1b156e7c06f534d66dd893c95614d1f6f3"
    sha256 cellar: :any, arm64_sequoia:     "081afe14e4651795170f4b5e0144a732e34f6693398deb7c79b5e5b930c2b1ba"
    sha256 cellar: :any, arm64_linux:       "df6818d4c168b84e3a926aff003053e3992c3d95a85adc2f4c1b5c0950f9b072"
    sha256 cellar: :any, x86_64_linux:      "e1694efc04635e1c06249c7a20895726711ff13652f8341a0454faf29fd7fe22"
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
