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
  end
end
