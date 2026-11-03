class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-12.2.0.tgz"
  sha256 "5aea6d89f3c54cfdff969430e1bcdc0212459806d74fd450d4a36d3144869a3b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a5b6816648c0c22bfb1f81cca48b6a32aaf736cd9c5744c3d58009f79d381ac5"
    sha256 cellar: :any,                 arm64_tahoe:       "a5b6816648c0c22bfb1f81cca48b6a32aaf736cd9c5744c3d58009f79d381ac5"
    sha256 cellar: :any,                 arm64_sequoia:     "a5b6816648c0c22bfb1f81cca48b6a32aaf736cd9c5744c3d58009f79d381ac5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5db5c3112b4d7289537303fccc21ef54afe1ba928e8c0ea10bfd6272143d7bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "26c2af00ff0c3cd74fd83cd61a7d6d9f23703148ed27884dfe7d305b7b5e1b5e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mermaid-js/mermaid-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmdc --version")

    (testpath/"diagram.mmd").write <<~EOS
      graph TD;
        A-->B;
        A-->C;
        B-->D;
        C-->D;
    EOS

    output = shell_output("#{bin}/mmdc -i diagram.mmd -o diagram.svg 2>&1", 1)
    assert_match "Could not find chrome-headless-shell", output
  end
end
