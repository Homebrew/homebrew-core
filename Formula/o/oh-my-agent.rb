class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.33.0.tgz"
  sha256 "2c797aa3ad29bf5879a1ce90ff7f1a6948a17fbd431ff693508eba65f5d6fcaa"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bb54e98b52e2a773148d9a0df452834726e0ebd3e79b5605209384d4c6416376"
    sha256 cellar: :any, arm64_tahoe:       "bbd43a1b43b03e0456de3e6632cde9b7d5f777150326f3c8309c300881b0d0d5"
    sha256 cellar: :any, arm64_sequoia:     "40e33b0ca8780fe9aa71a783140c4bffd67efbaa841cf14e4eff979b9982f720"
    sha256 cellar: :any, arm64_linux:       "668a743c6b0481b05f186c5682b889b933bb411ebd72d6016990065e0be12502"
    sha256 cellar: :any, x86_64_linux:      "c356112fcc7fdf95abce8ab1bb373534b5e848bc1510790a72bc1929a42e522b"
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
