require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.7.tgz"
  sha256 "822a3473d7a4bb9518f8aa02d00bce6f1b1e7d190b97f31272dd7e4879fee684"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85c142a73048ac6192381b4bb7556d3e16ea9d8409244fac5af68906ec89fd94" => :sierra
    sha256 "0ec9dc91c3b49d1b8a3c06394229b13e7210acf32874d80bb5909a9333b69e95" => :el_capitan
    sha256 "e4ed1e783dc9b120df88603fcc22f6c7e970cb22243d8d408256822e96ad32a2" => :yosemite
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
