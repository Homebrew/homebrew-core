require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.21.tgz"
  sha256 "9547d896501e332b9ad953c52e55d775ce51ae8dc41541980eb94e0844dc82e5"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77ed036b2d584a2bf7121625c292ec14dcc22b2e0c43afef0753ec9e50955d7b" => :sierra
    sha256 "8ef333ee2870fe40e94af7ef978cabf6aec72ee9fb53c43e0abfee72e1f85a1e" => :el_capitan
    sha256 "e2264ddccc643ef93bf8a63390b4d3c92130fe29ba019e81750e08170b762c35" => :yosemite
  end

  depends_on "node"

  def install
    inreplace "bin/run.js", "npm update -g heroku-cli", "brew upgrade heroku"
    inreplace "bin/run", "node \"$DIR/run.js\"",
                         "#{Formula["node"].opt_bin}/node \"$DIR/run.js\""
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
