class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.31.0.tgz"
  sha256 "8d222c537e511308c9d197f5cc40ae8a45f83222b09cb12a1951c8ba2c6cedca"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "05ed0c80cf4aaf709c6d053d23c9ad8615358e147724cd857aad7d4d2e59fc52"
    sha256 cellar: :any, arm64_tahoe:       "94d4ea76ed0025b92a5b8eb795a9d042d95027a528237ac0d01790d4e218d959"
    sha256 cellar: :any, arm64_sequoia:     "19127e54082786f94ffc47feea199c576d38b54f056b6fa598024f783dec1199"
    sha256 cellar: :any, arm64_linux:       "22e1f77bb8f0fba408c00dc72d0d851589943aff31d8c4cdee2229326c7cf631"
    sha256 cellar: :any, x86_64_linux:      "b951a48b65ce3cef1f594ff6ff828db7a71f9c950cc898a7ff4138ced9a4bf06"
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
