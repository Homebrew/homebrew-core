class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.2.0.tgz"
  sha256 "704073c791fc1fcec09cb9a9ffdfc3a199bccfbb6e1257597bafb09ff5462408"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "545fbf43ad201f4820720e7e116a31e3c2386d07c122394fa16812ad0cf3547a"
    sha256 cellar: :any,                 arm64_sequoia: "3aabc085105fff86a5ecfa346653082fe15b6d162a948128df5aa1f2830a93f6"
    sha256 cellar: :any,                 arm64_sonoma:  "3aabc085105fff86a5ecfa346653082fe15b6d162a948128df5aa1f2830a93f6"
    sha256 cellar: :any,                 sonoma:        "6a349bfbf584047613ac95b43521df5465e87c1b1c8c611f8a4be225d66b8cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e509234424d4f36a4e1b4e51d1d96ee6164ec96f9db6a0dc89461668bfcb4641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5330146871faf00abbc99e088be380b397294a8154728c4cc9286c1340786072"
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
