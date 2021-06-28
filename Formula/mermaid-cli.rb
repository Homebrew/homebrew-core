require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.11.0.tgz"
  sha256 "9fa34462054938ad996887a0e4081421c159728761e30254b0c0bae5b77df291"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "264827be1fe94cdfac09ce7cad82583d1ecdb77ae91e7ff93c037847ba59b5fc"
    sha256 cellar: :any, big_sur:       "93ef1ae2c5d8e279f25031776a6b2d4745ba5c495da6c440de2318f52b051cbc"
    sha256 cellar: :any, catalina:      "93ef1ae2c5d8e279f25031776a6b2d4745ba5c495da6c440de2318f52b051cbc"
    sha256 cellar: :any, mojave:        "93ef1ae2c5d8e279f25031776a6b2d4745ba5c495da6c440de2318f52b051cbc"
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
