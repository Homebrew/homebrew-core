require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.25.tgz"
  sha256 "f602ec22aa3d796b4f4e39378b25c390bf2b7dd0cf1c360c4e9e4d4ad0ba0144"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
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
