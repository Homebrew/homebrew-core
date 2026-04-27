class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.2.2.tgz"
  sha256 "0959f619aca434b749e0f7d81f2f6d7ee9fe8f49b68a835b816a62a004e5d240"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c825ac59cbe6c9eb7fb43b293ac185f57d7decefc4d47871e904f5f8c8affa1a"
    sha256 cellar: :any,                 arm64_sequoia: "55abcfdab4db408f8ab520f8d7d681f4f55df14d17cee6d97bf5793456398e88"
    sha256 cellar: :any,                 arm64_sonoma:  "55abcfdab4db408f8ab520f8d7d681f4f55df14d17cee6d97bf5793456398e88"
    sha256 cellar: :any,                 sonoma:        "cef47e5fcebef4a1a4e4f3ed1f26bac4cb07636d664f54ba333c8aec7df7ff5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970bd72d3311920eeb26fe87acebcfc1a3ee78a02385edbb62e74329190fc706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cafb6ac52e2a69bb5e92bc32ae1233ca599758417c05dfd6d740b58891330ebd"
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
