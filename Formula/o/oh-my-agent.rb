class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.3.0.tgz"
  sha256 "5ef1e3807e1d9fef24a3245f6020ba50c1ea2e23f767db0f1ad82a1b447088c5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "180a325ed4e2c6e8ef9928aaea782339688555b6de856f0666a5440fcd92aa9a"
    sha256 cellar: :any,                 arm64_sequoia: "184548cb37ede79404ce761d0392966adb2b220c3bac5f038eb531d8bb184405"
    sha256 cellar: :any,                 arm64_sonoma:  "184548cb37ede79404ce761d0392966adb2b220c3bac5f038eb531d8bb184405"
    sha256 cellar: :any,                 sonoma:        "ba5b525c45f446d0d2c2bd32bcdc106c8ca2d1cc4f15d722596f93b0c30272e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c5b4ea865fe775f2450cd0d666af47ad433578c5a209534ab905b6d2ce8454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb0e9a9b0e4f2dc909edc209b0a5065d553bff5218ab5983659a17c652c29ad6"
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
