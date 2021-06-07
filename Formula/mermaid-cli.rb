require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.10.2.tgz"
  sha256 "a0b07fd3291cb645f24ca61311bd3ec74e0f0e294b7725cd0edabfd5e5256240"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dbbd92838b1d11bd4e11eb5535fbd0c6f5b92c0afb411558a7c75116b71062dd"
    sha256 cellar: :any, big_sur:       "95ef7d2a52850f2074addcfd742ba346f737d1d25a6aeb250f7b222d4ea68c71"
    sha256 cellar: :any, catalina:      "95ef7d2a52850f2074addcfd742ba346f737d1d25a6aeb250f7b222d4ea68c71"
    sha256 cellar: :any, mojave:        "95ef7d2a52850f2074addcfd742ba346f737d1d25a6aeb250f7b222d4ea68c71"
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
