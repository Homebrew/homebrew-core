require "language/node"

class MermaidCli < Formula
  desc "This is a command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.8.3-2.tgz"
  sha256 "b1b616a17d713bad7638a4365c7b0bf50adbab684bb06818e8333e1ca82bb5a7"
  license "MIT"

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
    system "mmdc -i #{testpath}/test.mmd -o #{testpath}/out.svg"

    assert_predicate(testpath/"out.svg", :exist?)
  
  end
end
