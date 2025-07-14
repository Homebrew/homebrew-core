class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.6.0.tgz"
  sha256 "931a41e109b7d33d0da4881a4cef673f6d77b30219543f7496c5c003c64866df"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1554c8ebf97a5d2c57a5bfee58f0033bdd376d68fe6f0d75c25471b08dc39edc"
    sha256 cellar: :any,                 arm64_sonoma:  "1554c8ebf97a5d2c57a5bfee58f0033bdd376d68fe6f0d75c25471b08dc39edc"
    sha256 cellar: :any,                 arm64_ventura: "1554c8ebf97a5d2c57a5bfee58f0033bdd376d68fe6f0d75c25471b08dc39edc"
    sha256 cellar: :any,                 sonoma:        "e1c98aa4a1f5a240c0fd1ff09b3a223922f8e7a533e01f83d1a9db2570b00145"
    sha256 cellar: :any,                 ventura:       "e1c98aa4a1f5a240c0fd1ff09b3a223922f8e7a533e01f83d1a9db2570b00145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71ed2b6ad6cc7c83ffa85b349b30bbe326cfe61afee8988ff27b601dec1a4c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141bd60ec8618342e391e70117ee014da0fbc36c6c56f26b52aaa9310e0302aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@mermaid-js/mermaid-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
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
    assert_match "Could not find Chrome", output
  end
end
