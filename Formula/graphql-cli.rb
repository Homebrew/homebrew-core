require "language/node"

class GraphqlCli < Formula
  desc "Command-line tool for common GraphQL development workflows"
  homepage "https://github.com/Urigo/graphql-cli"
  url "https://registry.npmjs.org/graphql-cli/-/graphql-cli-4.0.0.tgz"
  sha256 "1517777bc00b35f3ca3cc7a5a0a639ee9562871e4f4ac3b67143cabc0b4e2222"
  license "MIT"

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

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/graphql-cli/node_modules/websocket/builderror.log"
  end

  test do
    script = (testpath/"test.sh")
    script.write <<~EOS
      #!/usr/bin/env expect -f
      set timeout -1

      spawn #{bin}/graphql init

      expect -exact "? What is the type of the project?"
      send -- "1\r"

      expect -exact "Select the best option for you"
      send -- "1\r"

      expect -exact "? What is the name of the project?"
      send -- "brew\r"

      expect -exact "? Which template do you want to start with your new Full Stack project?"
      send -- "1\r"
      expect -exact "? Do you want to have GraphQL Inspector tools for your frontend?"
      send -- "Y\r"
      expect -exact "? Do you want to have GraphQL Inspector tools for your backend?"
      send -- "Y\r"

      expect eof
    EOS

    script.chmod 0700
    system "./test.sh"

    assert_predicate testpath/"Full Stack", :exist?
    assert_predicate testpath/"brew", :exist?
    assert_match "full-stack-template", File.read(testpath/"brew/package.json")
  end
end
