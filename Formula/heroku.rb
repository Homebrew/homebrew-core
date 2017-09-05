require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.16.tgz"
  sha256 "254817a26339d070a7a89cc425968e0c6cd7d2233201d96a84c72ea1f3f7e563"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa9eebfbf1015dc378e5c2d0dc823ae57b24de6481eb6645aaa3eb7d3e07131d" => :sierra
    sha256 "04a7bcde8f70fe16de754eea5c0c1f67bd3cd5518a4b780602404fc6167ff9cc" => :el_capitan
    sha256 "dec031f90c20c0be8dfa9e9dab2c3608cf81c855a497e21dca85a38538fc213d" => :yosemite
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
