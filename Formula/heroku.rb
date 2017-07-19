require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.11.tgz"
  sha256 "5420fae717c175de3acba2f1e444af799a2e587efe16e4aab7c351ce6264bbc3"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72fb6f833b16effaa899df7c67703ed915fcd5d7df12ef36621e6ec0006301d1" => :sierra
    sha256 "304f42296136901c8e2502fcf58fad1dcece960f5e3218b2d7a8ea8a04711030" => :el_capitan
    sha256 "5e15ad595e4cd4b0fbfee5aae2d0e023ff249fd1ee743afbe3a2da574d1c6783" => :yosemite
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
