require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.24.tgz"
  sha256 "2b327b63479f24bd21a3beb56134dcb9218021f31b3fbc45ad694b35b05f186e"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "105ac1ed1645efb734d6463c1098d8a272ac8a21fc7437faa61f1e8b5a863815" => :high_sierra
    sha256 "ad4901a51f90130b1b85aa72872376a56fb74154a76550ce03cef23624d38f15" => :sierra
    sha256 "d6b9ec54ea5832cd9b16b7f95dc752455329fbb849f32eb7f64c289f6faa5daa" => :el_capitan
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
