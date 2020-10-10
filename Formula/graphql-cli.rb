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
    sha256 "5ecb75b7aa2887d2a7e81fe08b3cb18cb62e0dfe38d57eaa2cfa7fd636dab625" => :catalina
    sha256 "a9c8667aebd1344a6bfb265180054a6e063122da8a567fc62d54f05cd62f5ab9" => :mojave
    sha256 "be04819e9354a609deb3e075510e324eb5c7520d43eafc1b589ea03da487a3b0" => :high_sierra
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
