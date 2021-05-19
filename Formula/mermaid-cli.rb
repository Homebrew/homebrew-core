require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.10.1.tgz"
  sha256 "01a3fc212dabcba498942f9e2520f24b26758151a0f9b3ab82c1c1fe85ad3150"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "12409246875f59713ec10d1ae04baee79f6eb9d95c003aa0a0e0501f38e7ee25"
    sha256 cellar: :any, big_sur:       "1fe406f5cbec5a904c6a0f231acf94c016c6059814ac64958f57715b30371731"
    sha256 cellar: :any, catalina:      "1fe406f5cbec5a904c6a0f231acf94c016c6059814ac64958f57715b30371731"
    sha256 cellar: :any, mojave:        "1fe406f5cbec5a904c6a0f231acf94c016c6059814ac64958f57715b30371731"
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
