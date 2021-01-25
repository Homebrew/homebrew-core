require "language/node"

class GraphqlCli < Formula
  desc "Command-line tool for common GraphQL development workflows"
  homepage "https://github.com/Urigo/graphql-cli"
  url "https://registry.npmjs.org/graphql-cli/-/graphql-cli-4.1.0.tgz"
  sha256 "c52d62ac108d4a3f711dbead0939bd02e3e2d0c82f8480fd76fc28f285602f5c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "02d60908557d5dedf63fffe66a51f5829807abd910b5460a2ae44d7b8d208142" => :big_sur
    sha256 "2da205bbd5c76588be334a84b52dacfac9062045d605ed3f8298b7cb7b9b84a7" => :arm64_big_sur
    sha256 "5060d007d13a695709ff9afaa16a1492d8645e17ab78ec2b14650e0c7a305e55" => :catalina
    sha256 "212bf2d20997a930838775736ca468dc25cbd3c3978c0189f8a435873a029286" => :mojave
    sha256 "d8f266f129027b1fe731c12264f7b8679c271ecdb6418cef72dba0a730e99771" => :high_sierra
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

      expect -exact "Select the best option for you"
      send -- "1\r"

      expect -exact "? What is the name of the project?"
      send -- "brew\r"

      expect -exact "? Choose a template to bootstrap"
      send -- "1\r"

      expect eof
    EOS

    script.chmod 0700
    system "./test.sh"

    assert_predicate testpath/"brew", :exist?
    assert_match "Graphback runtime template with Apollo Server and PostgreSQL",
      File.read(testpath/"brew/package.json")
  end
end
