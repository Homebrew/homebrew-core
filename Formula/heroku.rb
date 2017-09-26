require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.27.tgz"
  sha256 "cffcf63c77638f53c471149b3ea29c09b1d9d1a5e3f06ea3ae687c7a24b429cb"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any
    sha256 "d9edf7d6335f05b5638613e9edf402a0c534fecf5be60ffe2d2d9fb7a6c270a4" => :high_sierra
    sha256 "0211d6b6dcc37fdd9c6835d97db2ea76240b13f057b86128bd2882fac1648985" => :sierra
    sha256 "bce50b4b5fd8bc94db22fb00d9fc9176ff5db9f7b4517e247c5491fc6c95d2fd" => :el_capitan
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
