require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.9.2.tgz"
  sha256 "29082de0a5c57a191406e18736554bc2388f7e4c18d3b58db061598a11813df0"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "e3ac57c32c19fd58687a03509677f351fecf466d92e8019928e3fdc21279d5a9"
    sha256 cellar: :any, catalina: "d0cf054b4245526439a5dd8ad76b7c2346b936c6e4362bfebf972e2395acc134"
    sha256 cellar: :any, mojave:   "aa18c46c9e58c635b85940d295c79f09a04c7a5a21a323d5ed9fbaa707f47358"
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
