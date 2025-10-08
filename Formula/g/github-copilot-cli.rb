class GithubCopilotCli < Formula
  desc "Brings AI-powered coding assistance to your command-line"
  homepage "https://github.com/github/copilot-cli"
  url "https://registry.npmjs.org/@github/copilot/-/copilot-0.0.333-10.tgz"
  sha256 "96744ddef561de788ef3212a13ec162f7290aefe5beefc21a535d36f362e29b3"
  license :cannot_represent

  depends_on "libsecret"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@github/copilot/node_modules"
    node_modules.glob("{keytar-forked-forked,node-pty}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/copilot --version")
  end
end
