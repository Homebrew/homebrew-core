class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-12.2.0.tgz"
  sha256 "5aea6d89f3c54cfdff969430e1bcdc0212459806d74fd450d4a36d3144869a3b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "db05323cf6a5485488e6f9f1efd153a7f191a625fae3e7afca744db36fff9371"
    sha256 cellar: :any,                 arm64_tahoe:       "db05323cf6a5485488e6f9f1efd153a7f191a625fae3e7afca744db36fff9371"
    sha256 cellar: :any,                 arm64_sequoia:     "db05323cf6a5485488e6f9f1efd153a7f191a625fae3e7afca744db36fff9371"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "417e2f41f528b3af2831669949bd1777ee4dee3f7fd9f598afbeb1e6b3d6c7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1c56ffe763302fb7f3c76785750fed99e1bf9c80c7aeb750deac0f913840997a"
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
