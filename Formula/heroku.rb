require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.5.tgz"
  sha256 "941320b806922a4e9d9035844991f28458ae7e52c32080162d26f4c947aa2636"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17fb8bd564c4233392047ab8b17dff0f33e818b482abc7c0d3c8c0575c5cd4a0" => :sierra
    sha256 "fd71fe14905084d44190de2a66c0ea70a4c3934e2e6a46075e6c785c676930c4" => :el_capitan
    sha256 "9bdbae7f53c81edad257a7b8a1628d102f48404500f483756027e7203432fd7e" => :yosemite
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
