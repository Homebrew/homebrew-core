class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.12.1.tgz"
  sha256 "95a09b04b668d2f752bcd5ffdc72a67bfb13ea8d4a163a1ec41bf5e4aec879c4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "822b2e1caf627bf3525a4e883f14e07d7715771163e324eafa521908b457b9fb"
    sha256 cellar: :any, arm64_sequoia: "2e0e7797b7c4c75915dc596eca128dbdfabf773ef6c55342f361c1dd0a5f407e"
    sha256 cellar: :any, arm64_sonoma:  "2e0e7797b7c4c75915dc596eca128dbdfabf773ef6c55342f361c1dd0a5f407e"
    sha256 cellar: :any, sonoma:        "6ae34393926ec7c6c5e66dfd1aa7d907479ddb2303854491f248c90e357d38a7"
    sha256 cellar: :any, arm64_linux:   "9dc2871f6c378b185b2fda4f3b5b1855326181d75b28648026c078bafb197a00"
    sha256 cellar: :any, x86_64_linux:  "b387a331d57575ac0cb72099736bb5c222ce42da3c0a3c8ac15a587f953b84ff"
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
