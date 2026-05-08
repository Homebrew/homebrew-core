class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.14.0.tgz"
  sha256 "fec919124ef10078fcf06357fcec2214a28c52260579d1aaf677cbe37e8120d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d165bdb0de11cc9707199536556e9fd7190d92be82ebebc609f05f1e96b75e8"
    sha256 cellar: :any,                 arm64_sequoia: "43d7b13abe3a73f2ae945bab9c85c25c74c523c643bc23bd8392308999bd25d0"
    sha256 cellar: :any,                 arm64_sonoma:  "43d7b13abe3a73f2ae945bab9c85c25c74c523c643bc23bd8392308999bd25d0"
    sha256 cellar: :any,                 sonoma:        "aeab34243cf0e2912ac48c7bb104229a97e4f1c4295d1dd55c235e7a57ef7037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3184c0e63a623405461f0a6afe6836c37134fa30578fd4651e3e1a6f30a9c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e5dc77aea50daf1a67f43f2ba41134de29eb0f7e26be8211b404a64ae6f499"
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

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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
