class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.4.1.tgz"
  sha256 "8dbaaa2387ae196f665248bca5ba58f77e10a53e96e81411e7c17a175087243a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d291d3d2eea687d669e3aa2756b32dedf2fbfa9833ad4c6342c191e52adea814"
    sha256 cellar: :any, arm64_sequoia: "ea3f42ba9e2581ab288170f0b57d23b4507134fbddf165cb91d963bf00b60efe"
    sha256 cellar: :any, arm64_sonoma:  "ea3f42ba9e2581ab288170f0b57d23b4507134fbddf165cb91d963bf00b60efe"
    sha256 cellar: :any, sonoma:        "40cecb891c384042a802600894b09736eabbe5c97a2d58ef30189577b0d0760b"
    sha256 cellar: :any, arm64_linux:   "859ef4b7e0a942b87c385460d0548bb387bc798093eb3d24f4ba6fbd23276c24"
    sha256 cellar: :any, x86_64_linux:  "c0e1115d49656de13b55930cc04607766f8b77eb800cf8975d99cf24d3c5adfa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
