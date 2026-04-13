class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.22.4.tgz"
  sha256 "421483ce85226da1e85ec4d6dd69fedcbba58df8c5735998d01d73be31441f8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ca0471625d87927038a7747d7d4a6707087b96ce23aa059d055a1ba79044f48"
    sha256 cellar: :any,                 arm64_sequoia: "3e94c7452eff7bedbe611bed8d9e618a821edd6dc71ffdb38b1567037769be2c"
    sha256 cellar: :any,                 arm64_sonoma:  "3e94c7452eff7bedbe611bed8d9e618a821edd6dc71ffdb38b1567037769be2c"
    sha256 cellar: :any,                 sonoma:        "640311e15dd48ec1a4a00e677a3e459ffd88f1c8d0b172af1434d68d6c753c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9376e652f039f29cc8ae5f3752181e06ff768f39cf787cfdbfc02072ba30d56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a5ca00d3d3eb5f17490b3abea5ba4345d9927c03ce5dbd1b2e86e6d19be505"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
