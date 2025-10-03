class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.12.0.tgz"
  sha256 "c59e2b7ec010d7a27a45b4addcde97978c644b1e996609e39714ea52d8926837"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7585648a49d157ad32707c73aa4dff41b4d06a38261d8df4909c5a09c282c581"
    sha256 cellar: :any,                 arm64_sequoia: "c6fbf4fbb0ccd2a1e4d2c13a1ffadeb5e5a8f5c49a9665f1e5a9e8248082e309"
    sha256 cellar: :any,                 arm64_sonoma:  "c6fbf4fbb0ccd2a1e4d2c13a1ffadeb5e5a8f5c49a9665f1e5a9e8248082e309"
    sha256 cellar: :any,                 sonoma:        "b2fb3aa586d4644029bf858d189adf7ff879c8383b396a6ac2cc7fd8cb9ab9c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f139c590db72914dd6bb29ccbc38caeba011433dbbd0048b91c601f1f449d7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32ef5ace7620a06092136d9900497f2fe55a15693d28a3b50bb2ce62af7b68af"
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
