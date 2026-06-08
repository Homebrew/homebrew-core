class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.15.0.tgz"
  sha256 "f6fd0879dbf500e453784bbd9db92ae951097e0e9e8a90ec613f2bd3ca8fa06c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d53c477501abf6c7516a6555807ca657d2c8728e12c34ea5be250f8f4a28acee"
    sha256 cellar: :any,                 arm64_sequoia: "d7474f1d8a9f7d2c022d2be73a9d32b0af4e9c4dd8ff9f61c951c0dc2643f1a3"
    sha256 cellar: :any,                 arm64_sonoma:  "d7474f1d8a9f7d2c022d2be73a9d32b0af4e9c4dd8ff9f61c951c0dc2643f1a3"
    sha256 cellar: :any,                 sonoma:        "77c4a31622a53c853dd98d9fd4688d9a4277aa316ecc08b423593e6f1ed3ef33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa4b183127c5ce5e7b72bcf2ef317f3b48eb480eaf4fac1df87e44b908c89b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ddf63dbb9f9f1e99961c967d676d01e6afe764008bdc632ccc9c752e70bae1"
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
