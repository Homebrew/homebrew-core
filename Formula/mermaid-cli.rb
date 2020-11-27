require "language/node"

class MermaidCli < Formula
  desc "This is a command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.8.1.tgz"
  sha256 "d26f6c9828e62e2771b56cb5a5e4f426714e6c0547921a5d0248424e94215b91"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
  
  shell_output("\
      cat << EOF | mmdc -o testpath/out.svg\
      sequenceDiagram\
          participant Alice\
          participant Bob\
          Alice->>John: Hello John, how are you?\
          loop Healthcheck\
              John->>John: Fight against hypochondria\
          end\
          Note right of John: Rational thoughts <br/>prevail!\
          John-->>Alice: Great!\
          John->>Bob: How about you?\
          Bob-->>John: Jolly good!\
      EOF\
    ")
  
    assert_predicate(testpath/"out.svg", :exist?)
  
  end
end
