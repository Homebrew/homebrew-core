class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.13.0.tgz"
  sha256 "56fa872b667829c6354ee728a3a1d6d47af70762530b478696b72abff1f18735"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c54552e1af9cadb86b33b6ef50547ef17c495db787057fdefb1a4c35f191392f"
    sha256 cellar: :any, arm64_tahoe:       "b1ba15a4885b87100a09070b0adfc3920a897eece178dcaf211c1ce99e0faa32"
    sha256 cellar: :any, arm64_sequoia:     "0969b338febf732d364efb28c85865d0d35ab5b129e2d15e10c0f6186a58ff2c"
    sha256 cellar: :any, arm64_linux:       "984f561e409f6e96f6d3dc9cdfb0b01ddeb1e74993b843a901e5dea894d83539"
    sha256 cellar: :any, x86_64_linux:      "9f3d26382556606f8af68bb28ad2b3ba70285e663b9f6f9908fda58232f20ed4"
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
