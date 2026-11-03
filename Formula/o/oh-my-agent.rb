class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.30.0.tgz"
  sha256 "7cf555c3bb9b5c7bcf8dce736365dbf465d63485a058e8b7101cfbf6c0830729"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "19227773c2cc1760f184b1e1d221a69a36b2ebb9cf860076e13ea0b18ea1afa6"
    sha256 cellar: :any, arm64_tahoe:       "4444ebbc077cfcac1d00cda4cedaff17d7ef34f37ad45ea6d8e09d62442b2dbd"
    sha256 cellar: :any, arm64_sequoia:     "0e9b11fac274cfe7859e319ac480e30491aac3e5276acd1750ddefe574a031d4"
    sha256 cellar: :any, arm64_linux:       "017afa1f009558bc4b00ac8a147c5828a4d819bc65760fa23f69780123f8b28b"
    sha256 cellar: :any, x86_64_linux:      "0d985dfe1e717e99a1098d78a1712fe79a158dfb0ac7809756cdae40fe549d5d"
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
