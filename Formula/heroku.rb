require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.30.tgz"
  sha256 "d851958b6b45bdcaef92b0b90dba8d1f3b30e25e6ad640d7f44f1d28d832e840"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "700f34f56df026ab998ebcd81382b345bbb77e11eb334b8a34255ad6b7ea2379" => :high_sierra
    sha256 "4dda0befb042204fe4f51583d1663c0b2f60282e825b865cfb3f6539717a9535" => :sierra
    sha256 "bda7136d82a6e1d03bf85a21ccbdd0f7226b6a6bf1ae11b2a5f43ec89bd2410a" => :el_capitan
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
