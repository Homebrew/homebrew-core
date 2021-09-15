require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.11.0.tgz"
  sha256 "9fa34462054938ad996887a0e4081421c159728761e30254b0c0bae5b77df291"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "00f8dbde25e1d468f6a7f2b03126e0739e490486aefcf47cda68626f1768257f"
    sha256 cellar: :any, big_sur:       "b97919f1f15b8c36004a484cfe8ab6820a09e7f42bec6a493ecc2da5c8778a5c"
    sha256 cellar: :any, catalina:      "b97919f1f15b8c36004a484cfe8ab6820a09e7f42bec6a493ecc2da5c8778a5c"
    sha256 cellar: :any, mojave:        "b97919f1f15b8c36004a484cfe8ab6820a09e7f42bec6a493ecc2da5c8778a5c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mmd").write <<~EOS
      sequenceDiagram
          participant Alice
          participant Bob
          Alice->>John: Hello John, how are you?
          loop Healthcheck
              John->>John: Fight against hypochondria
          end
          Note right of John: Rational thoughts <br/>prevail!
          John-->>Alice: Great!
          John->>Bob: How about you?
          Bob-->>John: Jolly good!
    EOS

    (testpath/"puppeteer-config.json").write <<~EOS
      {
        "args": ["--no-sandbox"]
      }
    EOS

    system bin/"mmdc", "-p", "puppeteer-config.json", "-i", "#{testpath}/test.mmd", "-o", "#{testpath}/out.svg"

    assert_predicate testpath/"out.svg", :exist?
  end
end
