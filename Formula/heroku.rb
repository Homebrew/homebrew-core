require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.24.tgz"
  sha256 "2b327b63479f24bd21a3beb56134dcb9218021f31b3fbc45ad694b35b05f186e"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f9ef2bee125831e1de8b999e41b9909c5d13f80aba5ed4743ed1ee6e7b98ced" => :high_sierra
    sha256 "3ba624c6a99f74fe4c2004b14b5617aa2d5d2cc4942ad15f6b3d40d457e6480c" => :sierra
    sha256 "4654c1de090a760a45a2cf231a9d2ac381aacb509754b36cbfd4763b167178cd" => :el_capitan
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
