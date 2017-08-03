require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.7.tgz"
  sha256 "822a3473d7a4bb9518f8aa02d00bce6f1b1e7d190b97f31272dd7e4879fee684"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "89c0ed7ba8be5f287ae418fd8c5a218b8f8c89bcaeea5b7c12b3bfb17e84e1f3" => :sierra
    sha256 "be928e34d8c3a1f77415ef1fb058f835bb1863efa71213e05069eedf2f5530c4" => :el_capitan
    sha256 "5295aeec5876befd05449aec736cc0601c03a67d4ea6b2c39cd4fe3834d36e5a" => :yosemite
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
