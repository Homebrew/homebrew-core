class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.5.0.tgz"
  sha256 "2780c20d15db02170ab84262e4448fd1d1f958cd48349c7441c26894dae6b10b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5142e3a1826035364034db7db364c0324f152931f83e93657a88087565b212ad"
    sha256 cellar: :any, arm64_sequoia: "9524690bdbbc2be222a390795a4e88cb152042705cdefaf8ae08e07d2b8293e2"
    sha256 cellar: :any, arm64_sonoma:  "31caa2bef29e364938d7f7eed2d5272905f3910787e958d3774741509bfe4295"
    sha256 cellar: :any, sonoma:        "ff907067d9a763523733bd924a0ab06b29a14ca010a247fbfa5a9c637d0c7f3b"
    sha256 cellar: :any, arm64_linux:   "db1e7af60ed469deb3b6a6d07586641260c2dff9e14e9965c78eaa8a64a60acc"
    sha256 cellar: :any, x86_64_linux:  "fab20a5731adf1a75b354aba746189f1fa55080ba45896c8adcd8c15b6454616"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
