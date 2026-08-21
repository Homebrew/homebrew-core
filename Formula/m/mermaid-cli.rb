class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.16.0.tgz"
  sha256 "65d795191bf9ca6ca90a40a1ea30354a6a491e206674cafd4d9de62fe9075439"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cdd5c5032b83aedc5d10bec9a74ee43654970592073ba64115be4cc1abdaaf08"
    sha256 cellar: :any,                 arm64_sequoia: "d579a6b048de5e0c46e183806b88b07d12c0d54fada8ce6d29309d2017242e0f"
    sha256 cellar: :any,                 arm64_sonoma:  "d579a6b048de5e0c46e183806b88b07d12c0d54fada8ce6d29309d2017242e0f"
    sha256 cellar: :any,                 sonoma:        "6f6a26dc19182f53b0d232202cbd1194a8a38d5bac9d662caf321b268dd3d40d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8abd605aabdfee4abbda503a1eb56947fc17a49278b93a38666e736bd86fea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6760c187479ee2247307288f5b691e4d457f10a0440f2b992943c75f694bf732"
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
