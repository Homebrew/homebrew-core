require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.8.4-1.tgz"
  sha256 "d644776eb97539546e5cc5f4d978b8b5c2cf354b4a232422a07fd056a6e416c8"
  license "MIT"

  bottle do
    cellar :any
    sha256 "ec65fe9a5b90065f242b1bd9242c299d8e8920957789f53eca273c82d6a6321d" => :big_sur
    sha256 "d3349bbcfcf97eb001455f0c81d4b3d31936380d46d6439586b4f31485b15ad1" => :catalina
    sha256 "31b7bbed1063c16c2979512bde0a20cd3792be90f0485a2644fab649e0dfda83" => :mojave
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
