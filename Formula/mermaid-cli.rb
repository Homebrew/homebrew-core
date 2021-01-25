require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.8.4-1.tgz"
  sha256 "d644776eb97539546e5cc5f4d978b8b5c2cf354b4a232422a07fd056a6e416c8"
  license "MIT"

  bottle do
    cellar :any
    sha256 "a1f146280bdf459bd1c62f3032aa284991886e28ad254deee8e94dc23681eeca" => :big_sur
    sha256 "04a30ab774696f49ea0dcac6a2119078d32b3fc4f4488dadfb413d3a3959fa00" => :catalina
    sha256 "c85e4cfb11303b1ec32629e3c42cb6ea31e9dbb4582861629d8f6d9679b6ec2c" => :mojave
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
