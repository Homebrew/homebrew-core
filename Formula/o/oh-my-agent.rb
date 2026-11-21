class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-21.0.1.tgz"
  sha256 "b330bb8ef868581e32617af12387fa7d77cdb4ef431fe6063d455439cca2a4bf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d480190ee658e964a247ecf77fdc75619faaaea2a026f9f3782c6936946fe5d"
    sha256 cellar: :any, arm64_tahoe:       "176227b6d88c9aff61854dffdb18c5dddafae9e62d86b1f2c8c061899d6a42ee"
    sha256 cellar: :any, arm64_sequoia:     "861eb2c6eab67819620b571c568fcee50d521cadec4b4d9c13890fffd21b38b1"
    sha256 cellar: :any, arm64_linux:       "da159d82ce85c8d1de43189f441aa0d7d4d2068c7679ea9fb5aa67ff3dc9a0c6"
    sha256 cellar: :any, x86_64_linux:      "ddc56246b06559ad543a2cbdc57dab9d77a5d95ce20b5b883a5a5e20662ce986"
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
