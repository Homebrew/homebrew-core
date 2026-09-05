class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.17.0.tgz"
  sha256 "23f2c2722262d98347cf979da6d88bc8693eef2cd8798a38ac393a7f006938a0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95231880e1f86550a5b54289b9f6999068cb3a5323c8ab88de0e408060dd2017"
    sha256 cellar: :any,                 arm64_sequoia: "95231880e1f86550a5b54289b9f6999068cb3a5323c8ab88de0e408060dd2017"
    sha256 cellar: :any,                 arm64_sonoma:  "95231880e1f86550a5b54289b9f6999068cb3a5323c8ab88de0e408060dd2017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628623b4f972e428b4965ab1c37ffb71755adb6ff7ffe609426dfc4250c97ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a3b6a08e80f3c39f4b733c3bbfd4ce6ec5f46ff0d13ec89ddd5c844cac85d96"
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
