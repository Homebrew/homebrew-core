require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.9.1.tgz"
  sha256 "3e9257bbca0d59ca377362559c9ee565a9e15c7afa5e2ebb9e6a6e4d033318da"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "5635192d53af750c9b036b7128a41322b0f698463963023adbf5eab65c2e8afc"
    sha256 cellar: :any, catalina: "57ed759a7ba88759de07a3b456df58b4918e006fdba235a5e2bb7eb59a8a49ca"
    sha256 cellar: :any, mojave:   "fdf370a8efd089f84ac72d88ad37ededff2740b6f4702dba566cb045e7becafe"
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
