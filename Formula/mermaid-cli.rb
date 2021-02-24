require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.9.0.tgz"
  sha256 "deabdff01b246b1b95dd2605e202e3fca4499ac12112b39c7c696f68df56db42"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "503f1999378800866e6acea39608d2e7a80fc6d7956bed3ad5a9a2c3fb6f7f54"
    sha256 cellar: :any, catalina: "05015617b49fe9d215798fc16cc504afe92605fdf84fd93d1aeda3aa8c5f4e9f"
    sha256 cellar: :any, mojave:   "a1ef6b374cd599b41251985613ea840345630921499e86903cf1bd8f89048bfc"
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
