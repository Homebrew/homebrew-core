require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.27.tgz"
  sha256 "cffcf63c77638f53c471149b3ea29c09b1d9d1a5e3f06ea3ae687c7a24b429cb"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "519ae59fcf9bc94f624cd442df37cad26694008878b54216188cd5a2e38f4e66" => :high_sierra
    sha256 "fc29fb86cf149f162a2045285f95954b032de77edeeeb46f942e73faf21c22df" => :sierra
    sha256 "b38a4a11fb9bbf28015bce2ff820cf20e8cfca884961d11b5fb9859e385e165a" => :el_capitan
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
