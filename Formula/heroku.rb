require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.7.tgz"
  sha256 "9348fab0b5928a6cfb9e537541afc5359d658aaff8e7d9d5066e142c1f99ed3d"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5106b573fe5ebed1f53abe59e9fc22e4cbf4be9e5d89c13316b12283af590a30" => :sierra
    sha256 "7cd27688421bf5a21f91e0f62ce2191b67afc52ae74b8b13efc1b2312152edb4" => :el_capitan
    sha256 "b239f032b71af754b5f815e00056c3ed59147a9fc526eec4e6dcbd034774344d" => :yosemite
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
