class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.10.1.tgz"
  sha256 "478135ef9eec7dd495683e679cddcc00ba52ca8b78286d9f0da253f9c4d83d00"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9f801e76d2335944b5bfe93bce6835046e73c6e33de6dd04f99733caca1781a"
    sha256 cellar: :any,                 arm64_sequoia: "0657a1ada19ba4742c20499e5c816b57436dad3012f16f5aeebdb92b1d58e32b"
    sha256 cellar: :any,                 arm64_sonoma:  "0657a1ada19ba4742c20499e5c816b57436dad3012f16f5aeebdb92b1d58e32b"
    sha256 cellar: :any,                 sonoma:        "40c368028e66d822fa9d67ceebc0a8382b19cb8c052c19e3e180ac53e83e5e73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f77161bcfbd68dd8b64c863b7e8f1ed056699e731039e777b7700a4bfc582237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e3ced9cc06277df60faf0b6243e761adaa35ca9b5d70ff1545c540d70123f10"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
    assert_match "Could not find Chrome", output
  end
end
