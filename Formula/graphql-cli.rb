require "language/node"

class GraphqlCli < Formula
  desc "Command-line tool for common GraphQL development workflows"
  homepage "https://github.com/Urigo/graphql-cli"
  url "https://registry.npmjs.org/graphql-cli/-/graphql-cli-4.0.0.tgz"
  sha256 "1517777bc00b35f3ca3cc7a5a0a639ee9562871e4f4ac3b67143cabc0b4e2222"

  bottle do
    cellar :any_skip_relocation
    sha256 "62783d3c7488a1e1a228fd2e9567d9ff936ad96f16be56c541c486ea625e843a" => :catalina
    sha256 "15a20fa31664af3c398c15eb8d8f29e2a07f00ae3e81315a541dec3ee7c112c4" => :mojave
    sha256 "e48b7e202b04240f33743ebfa5171056e9de9cd6d668f2f50e92b324af46f751" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphql --version")
  end
end
