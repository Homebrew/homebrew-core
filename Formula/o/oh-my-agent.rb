class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.14.0.tgz"
  sha256 "c8c8721a16f569a26f127b7f00af33e2821a016dbd8663e0cdb96aebf7ea97ff"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7259bceee62568f3f5f9b5c4c5a33a0526b6b39bdf3236c596ac3fa1de221355"
    sha256 cellar: :any,                 arm64_sequoia: "92b17d200c793ecdbf16f79a77e9f8ca1fbcaa0bcda9787c48573284f58471a4"
    sha256 cellar: :any,                 arm64_sonoma:  "92b17d200c793ecdbf16f79a77e9f8ca1fbcaa0bcda9787c48573284f58471a4"
    sha256 cellar: :any,                 sonoma:        "ec281e235654ed21e156253ff7819b64c47c3f5a97b96d97e9b1d5dfd558316e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "671aea39a739da8bc3c93c0554408679932227dc7adba71e0edec32dbf065fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d3353ae25d6a15d884a2b93cf29cf2a252a4c7bfdd13f930b785ce4267d4db4"
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
