require "language/node"

class GraphqlCli < Formula
  desc "Command-line tool for common GraphQL development workflows"
  homepage "https://github.com/Urigo/graphql-cli"
  url "https://registry.npmjs.org/graphql-cli/-/graphql-cli-3.0.14.tgz"
  sha256 "bf56bbe425795198bf6fcc488f24fe10779327749671b1a331d4137684d8a72d"

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
    (testpath/".graphqlconfig.yaml").write <<~EOS
      projects:
        test:
          schemaPath: schema.graphql
    EOS

    script = (testpath/"test.sh")
    script.write <<~EOS
      #!/usr/bin/env expect -f
      set timeout -1

      spawn #{bin}/graphql add-project

      expect -exact "? Enter project name for new project: "
      send -- "homebrew\r"

      expect -exact "? Local schema file path: "
      send -- "\r"

      expect -exact "? Endpoint URL (Enter to skip): "
      send -- "\r"

      expect -exact "? Is this ok? (Y/n) "
      send -- "Y\r"

      expect eof
    EOS

    script.chmod 0700
    system "./test.sh"

    assert_match "homebrew", File.read(testpath/".graphqlconfig.yaml")
  end
end
