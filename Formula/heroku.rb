require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.2.tgz"
  sha256 "88c15815707d3c8da66143625002fde60246fb69abb00f95c01fea75b455e6c3"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fae8dfcbe0b8c1dd959c157b4567bbeea55c86de0c6ed8c7194a9524dbf3e8c7" => :sierra
    sha256 "2a2ff24f098fe8b7c99229877bef49222bc47c90238518a169ad7ec47d5921f2" => :el_capitan
    sha256 "22ddb2b24610774f011a83f91c59ea004474aa3bed358e03bc93c41d2a198727" => :yosemite
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
