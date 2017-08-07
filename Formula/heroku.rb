require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.8.tgz"
  sha256 "467c436f146198ad344d82572e3d3b75b148b832a0a8396811a86c9f019d37c3"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbfaed389c936e7ed0bf1ac09984e37ffdfbc8fd69cdce4576dbc68b1939d514" => :sierra
    sha256 "335575dc6877065fc218120aa4672f6eb3dd44f43ed5c4ae10a62e42bf62236c" => :el_capitan
    sha256 "36e1a31ce8ee2d5bb44a714b0c2a21c2c9cb5d104da962cc670ad0e19a8b1ba8" => :yosemite
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
